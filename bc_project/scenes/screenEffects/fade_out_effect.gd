extends Control

const step:float = 0.008
var state: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TextureRect.material.set("shader_parameter/state",state)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state <= 1:
		get_parent().queue_free()
	else:
		state = state + step
		$TextureRect.material.set("shader_parameter/state",state)
