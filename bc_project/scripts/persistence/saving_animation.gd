class_name SavingAnimation extends CanvasLayer

## Set when saving is done
var done: bool = false

func _ready() -> void:
	%AnimationRect.texture.current_frame = 0
	timeout()

## Controls animation until saving is done
func _process(delta: float) -> void:
	if %AnimationRect.texture.current_frame >= 15 and done:
		queue_free()

func timeout() -> void:
	await get_tree().create_timer(60.0).timeout
	queue_free()
