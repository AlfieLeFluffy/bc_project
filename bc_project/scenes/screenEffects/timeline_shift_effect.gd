extends MarginContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Animation.texture.current_frame = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Animation.texture.current_frame == 7:
		get_parent().queue_free()
