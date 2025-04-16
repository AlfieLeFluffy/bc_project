class_name Slide extends Control

#region Exported Variables
@export var timeout: float = 1.0
@export var skipable: bool = true
#endregion

#region Runtime Variables
var done: bool = false
var skip: bool = false
var active: bool = false

var tween: Tween
var timer: SceneTreeTimer
#endregion

#region Signals
signal s_Finished()
#endregion



#region Setup Methods
func _ready() -> void:
	visible = false
	modulate = Color.TRANSPARENT
#endregion



#region Runtime Methods
func run_sequence() -> void:
	visible = true
	active = true
	if not skip:
		await local_fade_to_color(self, Color.WHITE,1.0)
	if not skip:
		await _run_animation()
	if not skip:
		await local_fade_to_color(self, Color.TRANSPARENT,1.0)
	modulate = Color.TRANSPARENT
	active = false
	done = true
	s_Finished.emit()
	visible = false

func _gui_input(event: InputEvent) -> void:
	if not active:
		return
	if skipable and (event.is_action_pressed("interact") or event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_menu")):
		skip_slide()

func skip_slide() -> void:
	if active:
		skip = true
		if timer:
			timer.timeout.emit()
		if tween:
			tween.pause()
			tween.custom_step(1.0)
			tween.finished.emit()

func _run_animation() -> bool:
	if not skip:
		timer = get_tree().create_timer(timeout)
		await timer.timeout
	return true

func local_fade_to_color(item: CanvasItem, color: Color, duration: float = 0.3) -> bool:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(item,"modulate", color, duration)
	await tween.finished
	tween.kill()
	return true
#endregion
