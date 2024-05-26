extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction_y
var direction_x
var strength

var show_debug: bool = false

@export var player_id = 1:
  set(id):
    player_id = id
    $InputSynchronizer.set_multiplayer_authority(id)

func _enter_tree():
  motion_mode = MOTION_MODE_FLOATING
  $InputSynchronizer.set_multiplayer_authority(str(name).to_int())
  $MultiplayerSynchronizer.set_multiplayer_authority(1)

func _ready():
  #self.ready.connect(_on_ready)
  pass

#func _on_ready():
  #set_multiplayer_authority(player_id)

func _physics_process(delta):
  _apply_movement_from_input(delta)
  _render_debug()

func _apply_movement_from_input(delta):
  strength = $InputSynchronizer.strength
  direction_y = $InputSynchronizer.input_direction_y
  direction_x = $InputSynchronizer.input_direction_x
  
  if direction_y and strength > 0:
    velocity.y = direction_y * SPEED
  else:
    velocity.y = move_toward(velocity.y, 0, SPEED)
  
  if direction_x and strength > 0:
    velocity.x = direction_x * SPEED
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)

  move_and_slide()

func _render_debug():
  if not show_debug:
    $DebugLabel.hide()
    return
  
  var debug_text: String = "velocity: (%s, %s)" % [str(velocity.x), str(velocity.y)]
  debug_text += "\nstrength: %s" % str($InputSynchronizer.strength)
  debug_text += "\ndirection_y: %s" % str($InputSynchronizer.input_direction_y)
  debug_text += "\ndirection_x: %s" % str($InputSynchronizer.input_direction_x)
  
  $DebugLabel.text = debug_text
