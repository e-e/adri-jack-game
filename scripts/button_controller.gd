class_name ButtonController extends Control

signal button_pressed(btn: String)
signal button_released(btn: String)

func _on_up_button_pressed():
  button_pressed.emit("up")
  TouchScreenButton

func _on_up_button_released():
  button_released.emit()

func _on_down_button_pressed():
  pass
