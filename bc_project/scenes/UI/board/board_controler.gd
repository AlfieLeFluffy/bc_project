extends CanvasLayer

"""
--- Runtime Variables
"""
var mouse_offset

"""
--- Runtime Methods
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	$BoardControler.position = (DisplayServer.screen_get_size() /2) - Vector2i($BoardControler/BoardBackground.size/2)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("table_toggle"):
		toggle_board()

"""
--- General Methods
"""
func toggle_board() -> void:
	visible = not visible
