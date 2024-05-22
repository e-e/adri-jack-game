extends Node2D

var connected_user_row_scene: PackedScene = preload("res://scenes/connected_user_row.tscn")
@onready var nickname_input = $UI/RegisterContainer/TextEdit
@onready var error_message_label = $UI/RegisterContainer/Header_HBoxContainer/ErrorMessageLabel
@onready var adri_button = $UI/RegisterContainer/HBoxContainer/AdriButton
@onready var jack_button = $UI/RegisterContainer/HBoxContainer/JackButton

# Called when the node enters the scene tree for the first time.
func _ready():
  Logger.debug("is server? [%s]" % ["yes" if MultiplayerManager.is_server else "no"])
  SignalBus.connect("update_connected_users_signal", _update_users_list)
  error_message_label.hide()

func _update_users_list():
  Logger.debug("updating users list...")
  var list = $UI/ConnectedUsersContainer/VBoxContainer
  for child in list.get_children():
    child.queue_free()
  
  for user in MultiplayerManager.connected_clients:
    var row = connected_user_row_scene.instantiate()
    row.init(user)
    
    list.add_child(row)

func _on_join_button_pressed():
  error_message_label.hide()
  
  var nickname: String = nickname_input.text.strip_edges()
  var character: String = _get_selected_user()
  
  if nickname.length() == 0:
    error_message_label.text = "Pleaes enter a nickname"
    error_message_label.show()
    return
  
  if not ["adri", "jack"].has(character):
    error_message_label.text = "Pleaes select your player"
    error_message_label.show()
    return
  
  MultiplayerManager.join_server(nickname, character)
  $UI/RegisterContainer.hide()
  $UI/ConnectedUsersContainer.show()

func _get_selected_user() -> String:
  var selected: String = ""
  if adri_button.button_group.get_pressed_button() == adri_button:
    selected = "adri"
  if jack_button.button_group.get_pressed_button() == jack_button:
    selected = "jack"
  return selected
