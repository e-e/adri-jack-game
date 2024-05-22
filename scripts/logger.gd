extends Node

func debug(message: String):
  _log("DEBUG", message)

func info(message: String):
  _log("INFO", message)

func warn(message: String):
  _log("WARN", message)

func error(message: String):
  _log("ERROR", message)

func _log(level: String, message):
  var is_server: bool = OS.has_feature("dedicated_server")
  var id: String = str(multiplayer.get_unique_id()) if is_server or multiplayer.get_unique_id() != 1 else "local"

  print("[%s][%s] %s" % [level, id, message])
