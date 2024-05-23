extends Node2D

const match_scene: PackedScene = preload("res://scenes/screens/match.tscn")

var matches: Dictionary = {}

func get_match_key(users: Array) -> String:
  var ids: Array = users.map(func(user: Dictionary): return user.client_id)
  ids.sort()
  return "match_%s_%s" % [str(ids[0]), str(ids[1])]

func start_match(users: Array) -> void:
  Logger.debug("[%s]: type[0] = %s, type[1] = %s" % [typeof(users), typeof(users[0]), typeof(users[1])])
  var match_key: String = get_match_key(users)
  var new_match = match_scene.instantiate()
  
  new_match.name = match_key
  new_match.players = users
  matches[match_key] = users
  
  add_child(new_match)
  
  
