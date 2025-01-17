extends Control

"""
--- Runtime Variables
"""
var dragged = false
var mouseOffset

"""
--- Runtime Methods
"""
func _physics_process(delta: float) -> void:
	if dragged:
		position = get_global_mouse_position() + mouseOffset
		restrain_board()

func restrain_board() -> void:
	DisplayServer.screen_get_size()
	
	if position.x >= 0:
		position.x = 0
	
	if position.y >= 0:
		position.y = 0
	
	if position.x <= -$BoardBackground.size.x/2:
		position.x = -$BoardBackground.size.x/2
	
	if position.y <= -$BoardBackground.size.y/2:
		position.y = -$BoardBackground.size.y/2


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("drag_board") and visible:
		dragged = true
		mouseOffset = position - get_global_mouse_position()
	elif event.is_action_released("drag_board") and visible:
		dragged = false
