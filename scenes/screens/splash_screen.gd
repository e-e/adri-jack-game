class_name SplashScreen extends Node2D

signal splash_screen_finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  await get_tree().create_timer(3).timeout
  splash_screen_finished.emit()
  

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
  pass
