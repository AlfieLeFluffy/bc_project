extends MarginContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%TextureOutter.modulate = Color.TRANSPARENT
	%TextureFill.modulate = Color.TRANSPARENT
	await GameController.fade_to_color(%TextureOutter, Color.WHITE, 0.05)
	await GameController.fade_to_color(%TextureFill, Color.WHITE, 0.05)
	await GameController.fade_to_color(%TextureFill, Color.TRANSPARENT, 0.05)
	await GameController.fade_to_color(%TextureOutter, Color.TRANSPARENT, 0.05)
	get_parent().queue_free()
