@tool

class_name PlayerBase extends PlayerExports

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction_y
var direction_x
var strength
@export var health = 100

# actions
var do_use_item: bool = false

# debug
var show_debug: bool = false

# player/user data
var data

@onready var item: Item = $Item

@export var player_id = 1:
  set(id):
    player_id = id
    $InputSynchronizer.set_multiplayer_authority(id)

func _enter_tree():
  $InputSynchronizer.set_multiplayer_authority(str(name).to_int())
  $MultiplayerSynchronizer.set_multiplayer_authority(1)


#func _on_ready():
  #self.ready.connect(_on_ready)
  #set_multiplayer_authority(player_id)


func apply_flip_h(should_flip: bool):
  animation_player.flip_h = should_flip
  item.scale.x = -1 if should_flip else 1
  

func _physics_process(delta):
  if not Engine.is_editor_hint():
    _apply_movement_from_input(delta)
    _apply_animations(delta)
    _render_debug()

# note: the "flip_h" is done above in "apply_flip_h", but is called from the server's instance of the "match"
func _apply_animations(_delta):
  # server + client animations
  if do_use_item:
    item.use()
    do_use_item = false
  
  if MultiplayerManager.is_server:
    return
  
  # client only animations
  if strength == 0:
    animation_player.play("idle")
  else:
    animation_player.play("walk")
    
func _apply_movement_from_input(_delta):
  #if not MultiplayerManager.is_server:
    #return
  
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
    
  if do_use_item:
    item.use()

  move_and_slide()

func _render_debug():
  if not show_debug:
    $DebugLabel.hide()
    return
  
  var debug_text: String = "velocity: (%s, %s)" % [str(velocity.x), str(velocity.y)]
  debug_text += "\nstrength: %s" % str($InputSynchronizer.strength)
  debug_text += "\animation: %s" % animation_player.animation
  
  $DebugLabel.text = debug_text
