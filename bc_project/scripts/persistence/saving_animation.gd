class_name SavingAnimation extends CanvasLayer

## Set when saving is done
var done: bool = false

func _ready() -> void:
	timeout()

## Controls animation until saving is done
func _process(delta: float) -> void:
	if %AnimationRect.texture.current_frame >= 8 and not done:
		%AnimationRect.texture.current_frame = 8
	elif %AnimationRect.texture.current_frame >= 8 and done:
		if %AnimationRect.texture.current_frame >= 11:
			queue_free()

func timeout() -> void:
	await get_tree().create_timer(60.0).timeout
	queue_free()
