extends Node

var server_address: String = "adri-jack-game.eric.wtf"
var server_ws_address: String = "wss://adri-jack-game.eric.wtf"
var server_port: String = "16001"
var client_port: String = ":8081"

func _enter_tree() -> void:
  for arg in OS.get_cmdline_user_args():
    var key_value = arg.split("=")
    var key = key_value[0].lstrip("--")
    
    if key in self:
      self.set(key, key_value[1])
