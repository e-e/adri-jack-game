extends HBoxContainer

@onready var nickname_label = $NicknameLabel
@onready var status_label = $StatusLabel
@onready var join_button = $JoinButton
@onready var icon_jack = $Icon_Jack
@onready var icon_adri = $Icon_Adri

var user

func init(_user):
  self.user = _user
  
func _ready():
  nickname_label.text = user.nickname
  status_label.text = user.status
  
  if user.status != "lobby" or int(user.client_id) == multiplayer.get_unique_id():
    join_button.hide()
  
  icon_jack.visible = user.character == "jack"
  icon_adri.visible = user.character == "adri"
  
func _on_join_button_pressed():
  SignalBus.join_player_button_pressed.emit(user)
