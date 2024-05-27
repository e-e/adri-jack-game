class_name Match extends Node2D

const player_scene_adri: PackedScene = preload("res://scenes/player_adri.tscn")
const player_scene_jack: PackedScene = preload("res://scenes/player_jack.tscn")

@onready var spawn_point_adri = $SpawnPointAdri
@onready var spawn_point_jack = $SpawnPointJack

@onready var Players = $Players
@onready var button_controller: ButtonController = $ButtonController

var players: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
  if MultiplayerManager.is_server:
    _init_players()
  else:
    MultiplayerManager.current_match = self


func _on_button_pressed(btn: String):
  Logger.debug("button pressed: %s" % btn)

func _init_players():
  for player in players:
    Logger.debug("adding player %s" % player.nickname)
    var player_scene = _get_player_scene(player)
    print(player_scene)
    var spawn_point = _get_player_start_position(player)
    var player_node = player_scene.instantiate()
    print(player_node)
    print(spawn_point)
    player_node.position = spawn_point.position
    player_node.player_id = player.client_id
    player_node.name = str(player.client_id)
    $Players.add_child(player_node)

func _get_player_scene(user) -> PackedScene:
  return player_scene_adri if user.character == "adri" else player_scene_jack

func _get_player_start_position(user) -> Marker2D:
  Logger.debug("getting start position for [%s][%s]" % [user.nickname, user.character])
  print(spawn_point_adri)
  print(spawn_point_jack)
  return spawn_point_adri if user.character == "adri" else spawn_point_jack

func get_opponent_player_scene() -> PlayerBase:
  var player: PlayerBase
  for node in Players.get_children():
    if node.name != str(MultiplayerManager.player.client_id):
      player = node
      break
  return player
    
func _apply_flip_h():
  if not MultiplayerManager.is_server:
    return
  
  if Players.get_child_count() != 2:
    Logger.debug("match - waiting for two players")
    return
  
  var player_1 = Players.get_child(0)
  var player_2 = Players.get_child(1)
  
  if player_1.position.x == player_2.position.x:
    return
  
  var left_player: PlayerBase
  var right_player: PlayerBase
  
  if player_1.position.x < player_2.position.x:
    left_player = player_1
    right_player = player_2
  else:
    left_player = player_2
    right_player = player_1
  
  left_player.apply_flip_h(false)
  right_player.apply_flip_h(true)
  
func _physics_process(_delta: float) -> void:
  _apply_flip_h()
  
