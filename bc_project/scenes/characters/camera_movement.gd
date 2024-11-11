extends Node2D

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent()
	pass # Replace with function body.

	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		global_position = player.position.lerp(get_global_mouse_position(), 0.3); 
