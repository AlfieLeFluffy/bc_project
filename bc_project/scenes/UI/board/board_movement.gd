extends Control

#region Variables
var dragged = false
var mouseOffset
@onready var boardBackground: TextureRect = $BoardBackground
#endregion

#region Runtime Methods
func _physics_process(delta: float) -> void:
	if dragged:
		position = get_global_mouse_position() + mouseOffset
		restrain_board()

func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("drag_board"):
		mouseOffset = position - get_global_mouse_position()
		dragged = true
	elif visible and  event.is_action_released("drag_board"):
		dragged = false
#endregion

#region Restrain Methods
func restrain_board() -> void:
	position.x = min(position.x, 0)
	position.y = min(position.y, 0)
	
	position.x = max(position.x, -boardBackground.size.x/2)
	position.y = max(position.y, -boardBackground.size.y/2)
#endregion
