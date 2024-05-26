extends Node2D

@onready var pad_sprite = $PadSprite
@onready var button_sprite = $ButtonSprite

const PAD_RADIUS = 32
const BUTTON_RADIUS = 8

var strength: float = 0.0:
  get:
    return InputController.strength
  set(new_strength):
    InputController.strength = new_strength

# should always be normalized
var direction: Vector2 = Vector2(0, 0):
  get:
    return InputController.direction
  set(new_direction):
    InputController.direction = new_direction

var touch_position: Vector2 = Vector2(0, 0):
  get:
    return InputController.touch_position
  set(new_touch_position):
    InputController.touch_position = new_touch_position

var is_active: bool = false:
  get:
    return InputController.is_active
  set(new_is_active):
    InputController.is_active = new_is_active

var scale_factor: float = 3.0

func _ready():
  scale *= scale_factor

func _unhandled_input(event):
  if event is InputEventScreenTouch or event is InputEventMouseButton:
    print("global click position: (%s, %s)" % [str(event.position.x), str(event.position.y)])
    _handle_touch(event.position, event.pressed)
  
  if event is InputEventGesture:
    print("touch event: (%s, %s)" % [str(event.position.x), str(event.position.y)])

  if event is InputEventMouseMotion and is_active:
    _handle_touch(event.position, is_active)

func _is_touch_in_bounds(touch_pos: Vector2) -> bool:
  var adjusted_touch: Vector2 = global_position - touch_pos
  print("is withint bounds: %s" % str(adjusted_touch.length() <= PAD_RADIUS))
  return adjusted_touch.length() <= PAD_RADIUS

# @todo: not quite there - if releasing within the "pad", the button doesn't return to the middle
func _handle_touch(touch_pos: Vector2, pressed: bool) -> void:
  var was_active: bool = is_active
  
  # released
  if not pressed:
    touch_position = Vector2(0, 0)
    strength = 0
    #direction = Vector2(0, 0)
    is_active = pressed
    return
  
  # invalid touch
  if not _is_touch_in_bounds(touch_pos) and not was_active:
    touch_position = Vector2(0, 0)
    strength = 0
    #direction = Vector2(0, 0)
    return
  
  var adjusted_touch: Vector2 = global_position - touch_pos
  
  is_active = pressed
  touch_position = touch_pos
  strength = clampf(adjusted_touch.length() / (PAD_RADIUS * scale_factor), 0.0, 1.0)
  direction = adjusted_touch.normalized()

# assumes any scaling is done equally to x and y
func _magnitude() -> float:
  return (PAD_RADIUS - BUTTON_RADIUS) * strength


func _render_debug(new_position: Vector2) -> void:
  $StrengthLabel.text = "Strength: %s" % str(strength)
  $DirectionLabel.text = "Direction: (%s, %s)" % [str(direction.x), str(direction.y)]
  $PositionLabel.text = "Position: (%s, %s)" % [str(new_position.x), str(new_position.y)]
  
func _process(delta: float) -> void:
  var new_position: Vector2 = -(_magnitude() * direction)
  
  button_sprite.position = new_position
  pad_sprite.modulate = Color(0.8, 0.8, 0.8) if is_active else Color(1.0, 1.0, 1.0)
  
  _render_debug(new_position)

