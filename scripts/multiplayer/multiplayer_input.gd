extends MultiplayerSynchronizer

@onready var player: PlayerBase = $".."

var input_direction_x
var input_direction_y
var strength
var do_use_item

# Called when the node enters the scene tree for the first time.
func _ready():
  if get_multiplayer_authority() != multiplayer.get_unique_id():
    set_process(false)
    set_physics_process(false)
  
  _set_input_directions()
  
  SignalBus.action_button_pressed.connect(_on_action_button_pressed)

func _physics_process(delta):
  _set_input_directions()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  #if Input.is_action_just_pressed("jump"):
    #jump.rpc()
  pass

func _set_input_directions():
  strength = InputController.strength
  input_direction_x = InputController.input_direction_x
  input_direction_y = InputController.input_direction_y

func _on_action_button_pressed(action: String):
  Logger.debug("action button pressed signal received: %s" % action)
  match action:
    "item":
      use_item.rpc_id(1)

@rpc("any_peer")
func use_item():
  Logger.debug("RPC: use_item")
  if multiplayer.is_server():
    player.do_use_item = true

@rpc("authority")
func use_item_client():
  player.do_use_item = true

@rpc("call_local")
func jump():
  if multiplayer.is_server():
    player.do_jump = true
