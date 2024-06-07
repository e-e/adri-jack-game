class_name Item extends Node2D

@onready var animation_player: AnimationPlayer = $AnimatableBody2D/AnimationPlayer

func use():
  Logger.debug("[%s] using item" % get_parent().data.nickname)
  animation_player.play("hit")
  
