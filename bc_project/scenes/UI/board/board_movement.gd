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
	"""if Global.InMenu and visible and not dragged:
		var horizontal := Input.get_axis("ui_left", "ui_right")
		var vertical := Input.get_axis("ui_up", "ui_down")
		var direction = Vector2(horizontal*SPEED,vertical*SPEED)
		if horizontal or vertical:
			$Board.position = $Board.position + direction
	el"""
	if dragged:
		position = get_global_mouse_position() + mouseOffset

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("drag_board") and visible:
		dragged = true
		mouseOffset = position - get_global_mouse_position()
	elif event.is_action_released("drag_board") and visible:
		dragged = false
