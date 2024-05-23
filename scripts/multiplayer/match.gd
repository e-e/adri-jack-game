class_name Match extends Node2D

const player_scene_adri: PackedScene = preload("res://scenes/player_adri.tscn")
const player_scene_jack: PackedScene = preload("res://scenes/player_jack.tscn")

@onready var spawn_point_adri = $SpawnPointAdri
@onready var spawn_point_jack = $SpawnPointJack

@onready var Players = $Players

var players: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
  if MultiplayerManager.is_server:
    _init_both()
  #else:
     #_init_self()
  
  #if not MultiplayerManager.is_server:
    #_init_self()

func _init_self():
  var player_scene = _get_player_scene(MultiplayerManager.player)
  var spawn_point = _get_player_start_position(MultiplayerManager.player)
  var player_node = player_scene.instantiate()
  player_node.name = str(MultiplayerManager.player.client_id)
  player_node.player_id = MultiplayerManager.player.client_id
  player_node.position = spawn_point.position
  $Players.add_child(player_node, true)

func _init_both():
  for player in players:
    var player_scene = _get_player_scene(player)
    var spawn_point = _get_player_start_position(player)
    var player_node = player_scene.instantiate()
    player_node.position = spawn_point.position
    player_node.player_id = player.client_id
    player_node.name = str(player.client_id)
    $Players.add_child(player_node)

func _get_player_scene(user) -> PackedScene:
  return player_scene_adri if user.character == "adri" else player_scene_jack

func _get_player_start_position(user) -> Marker2D:
  return spawn_point_adri if user.character == "adri" else spawn_point_jack

