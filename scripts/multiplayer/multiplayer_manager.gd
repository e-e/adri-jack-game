extends Node

const SERVER_PORT = 8081
const SERVER_ADDRESS = "localhost"

var connected_clients = []

var is_server: bool = OS.has_feature("dedicated_server")

func _ready():
  if is_server:
    create_server()
  else:
    SignalBus.join_player_button_pressed.connect(_on_join_player_button_pressed)

func create_server():
  var server_peer = ENetMultiplayerPeer.new()
  server_peer.create_server(SERVER_PORT)
  
  multiplayer.multiplayer_peer = server_peer
  multiplayer.peer_connected.connect(_client_connected)
  multiplayer.peer_disconnected.connect(_client_disconnected)
  
  Logger.debug("server started: [id=%s]" % str(multiplayer.get_unique_id()))

func join_server(nickname: String, character: String):
  var client_peer = ENetMultiplayerPeer.new()
  var connection_error: int = client_peer.create_client(SERVER_ADDRESS, SERVER_PORT)
  
  if connection_error != 0:
    Logger.debug("[%s] failed to connect" % nickname)
    return
  
  multiplayer.multiplayer_peer = client_peer
  multiplayer.connected_to_server.connect(_on_successful_server_connection.bind(nickname, character))

func _client_connected(id: int):
  connected_clients.append({"client_id": id, "status": "lobby"})
  Logger.debug("client has connected: %s" % id)
  

func _client_disconnected(id: int):
  connected_clients = connected_clients.filter(func(client): return client.client_id != id)
  Logger.debug("client has disconnected: %s; %s remaining" % [id, str(connected_clients.size())])
  _update_connected_user_list.rpc(connected_clients)

func _on_successful_server_connection(nickname: String, character: String):
  Logger.debug("successfully connected to server")
  _set_client_nickname.rpc_id(1, multiplayer.get_unique_id(), nickname, character)

@rpc("authority")
func _update_connected_user_list(users: Array):
  var sender_id = multiplayer.get_remote_sender_id()

  if not multiplayer.is_server():
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

func _on_join_player_button_pressed(user_to_join):
  Logger.debug("[%s] user wants to join [%s]" % [str(multiplayer.get_unique_id()), str(user_to_join.client_id)])
  
  
    
