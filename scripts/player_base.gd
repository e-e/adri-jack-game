extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction_y
var direction_x

@export var player_id = 1:
  set(id):
    player_id = id
    $InputSynchronizer.set_multiplayer_authority(id)

func _physics_process(delta):
  _apply_movement_from_input(delta)

func _apply_movement_from_input(delta):
  direction_y = $InputSynchronizer.input_direction_y
  direction_x = $InputSynchronizer.input_direction_x
  
  if direction_y:
    velocity.y = direction_x * SPEED
  else:
    velocity.y = move_toward(velocity.y, 0, SPEED)
  
  if direction_x:
    velocity.x = direction_x * SPEED
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)

  move_and_slide()
