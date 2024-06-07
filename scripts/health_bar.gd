class_name HealthBar extends Control

var player: PlayerBase

@onready var bar: TextureProgressBar = $VBoxContainer/ProgressBar
@onready var label_margin: MarginContainer = $VBoxContainer/NameMargin
@onready var label: Label = $VBoxContainer/NameMargin/NameLabel

var alignment = {
  "adri": HORIZONTAL_ALIGNMENT_RIGHT,
  "jack": HORIZONTAL_ALIGNMENT_LEFT,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  if MultiplayerManager.is_server:
    label.text = player.data.nickname

func _on_test_health():
  if not MultiplayerManager.is_server:
    return
  if player.health > 0:
    player.health -= 10
    if player.health < 0:
      player.health = 0

    
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  if MultiplayerManager.is_server:
    bar.value = player.health
    if player.health > 75:
      bar.tint_progress = Color.AQUAMARINE
    elif player.health > 50:
      bar.tint_progress = Color.YELLOW
    elif player.health > 25:
      bar.tint_progress = Color.CORAL
    else:
      bar.tint_progress = Color.RED
