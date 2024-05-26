extends Node

var strength: float = 0
var direction: Vector2 = Vector2(0, 0)
var touch_position: Vector2 = Vector2(0, 0)

var is_active: bool = false

var input_direction_x: float = 0.0
var input_direction_y: float = 0.0

func _physics_process(delta):
  _set_input_from_touch_controller(delta)
  #_set_input_directions(delta)

func _set_input_directions(delta):
  if is_active:
    return
  input_direction_x = Input.get_axis("move_left", "move_right")
  input_direction_y = Input.get_axis("move_up", "move_down")

func _set_input_from_touch_controller(delta):
  if not is_active:
    return
  
  input_direction_x = -strength * direction.x
  input_direction_y = -strength * direction.y
  
  print("input_direction: (%s, %s)" % [str(input_direction_x), str(input_direction_y)])
