extends Node2D

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and not Global.InMenu:
		global_position = player.position.lerp(get_global_mouse_position(), 0.3); 
