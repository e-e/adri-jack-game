extends Node

var connected_clients = []
var opponent
var player
var current_match: Match

var is_server: bool = OS.has_feature("dedicated_server")
const match_room_scene: PackedScene = preload("res://scenes/screens/match.tscn")

var use_websocket: bool = true
var is_multiplayer_connected: bool = false

func _ready():
  if is_server:
    create_server()
  else:
    SignalBus.join_player_button_pressed.connect(_on_join_player_button_pressed)

func _process(_delta):
  if use_websocket:
    multiplayer.multiplayer_peer.poll()

func create_server():
  var server_peer
  if use_websocket:
    server_peer = WebSocketMultiplayerPeer.new()
    server_peer.create_server(int(Config.server_port), "0.0.0.0")
  else:
    server_peer = ENetMultiplayerPeer.new()
    server_peer.create_server(int(Config.server_port))
  
  multiplayer.multiplayer_peer = server_peer
  multiplayer.peer_connected.connect(_client_connected)
  multiplayer.peer_disconnected.connect(_client_disconnected)
  
  is_multiplayer_connected = true
  
  Logger.debug("server started: [id=%s]" % str(multiplayer.get_unique_id()))

func join_server(nickname: String, character: String):
  Logger.debug("[%s] wants to join server [%s]" % [nickname, Config.server_address])
  var client_peer
  var connection_error
  
  if use_websocket:
    client_peer = WebSocketMultiplayerPeer.new()
    connection_error = client_peer.create_client("%s%s" % [Config.server_ws_address, Config.client_port])
  else:
    client_peer = ENetMultiplayerPeer.new()
    connection_error = client_peer.create_client(Config.server_address, int(Config.client_port))
  
  if connection_error != 0:
    Logger.debug("[%s] failed to connect" % nickname)
    return
  
  multiplayer.multiplayer_peer = client_peer
  multiplayer.connected_to_server.connect(_on_successful_server_connection.bind(nickname, character))

func _client_connected(id: int):
  connected_clients.append({"client_id": id, "status": "lobby"})
  Logger.debug("client has connected: %s" % id)
  is_multiplayer_connected = true
  

func _client_disconnected(id: int):
  connected_clients = connected_clients.filter(func(client): return client.client_id != id)
  Logger.debug("client has disconnected: %s; %s remaining" % [id, str(connected_clients.size())])
  _update_connected_user_list.rpc(connected_clients)

func _on_successful_server_connection(nickname: String, character: String):
  Logger.debug("successfully connected to server")
  _set_client_nickname.rpc_id(1, multiplayer.get_unique_id(), nickname, character)

@rpc("authority")
func _update_connected_user_list(users: Array):
  if not is_server:
    connected_clients = users
    SignalBus.update_connected_users_signal.emit()

@rpc("any_peer")
func _set_client_nickname(id: int, nickname: String, character: String):
  for client in connected_clients:
    if int(client.client_id) == (id):
      client.nickname = nickname
      client.character = character
      Logger.debug("set nickname for client[%s]: %s" % [str(id), nickname])
      break
  
  _update_connected_user_list.rpc(connected_clients)

# this is called using rpc_id, so shouldn't need to verify that only the
# server is being called
@rpc("any_peer")
func _create_room(joined_client_id: int, joining_client_id: int):
  var joining_user = get_user_by_id(joining_client_id)
  var joined_user = get_user_by_id(joined_client_id)
  
  # if we for some reason couldnt match them
  if not joining_user or not joined_user:
    Logger.error("Could not find both users - joining[%s] / joined[%s]" % ["missing" if joining_user == null else "found", "missing" if joined_user == null else "found"])
    return
  
  Logger.debug("[%s] wants to join [%s]" % [joining_user.nickname, joined_user.nickname])
  
  joining_user.status = "playing"
  joined_user.status = "playing"
  
  _join_room.rpc_id(joining_user.client_id, joined_user.client_id)
  _join_room.rpc_id(joined_user.client_id, joining_user.client_id)
  
  # test to see if making sure both clients are in the room first fixes the issue of nodes not being found
  #await get_tree().create_timer(3).timeout
  
  SignalBus.create_and_enter_match.emit([joining_user, joined_user])
  _update_connected_user_list.rpc(connected_clients)

@rpc("authority")
func _join_room(opponent_client_id: int):
  opponent = get_user_by_id(opponent_client_id)
  player = get_user_by_id(multiplayer.get_unique_id())
  
  Logger.debug("joining [%s] in a room" % opponent.nickname)
  SignalBus.create_and_enter_match.emit([opponent, player])

func _on_join_player_button_pressed(user_to_join):
  Logger.debug("[%s] user wants to join [%s]" % [str(multiplayer.get_unique_id()), str(user_to_join.client_id)])
  _create_room.rpc_id(1, user_to_join.client_id, multiplayer.get_unique_id())


func get_user_by_id(id: int) -> Dictionary:
  var user
  for client in connected_clients:
    if client.client_id == id:
      user = client
      break
  
  return user
