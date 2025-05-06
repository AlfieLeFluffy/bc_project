class_name CameraTweenController extends Node2D

@export_range(0.0,5.0,0.1) var duration: float = 1.5
@export var startPosition: Vector2 = Vector2(0.0,-100.0)
@export var endPosition: Vector2 = Vector2(0.0,0.0)

var tween: Tween

func _ready() -> void:
	position = startPosition
	tween = create_tween()
	tween.finished.connect(tween_done)
	tween.tween_property(self,"position",endPosition,duration).set_ease(Tween.EASE_IN)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event.is_action_pressed("interact") or event.is_action_pressed("ui_menu"):
		if tween:
			tween.pause()
			tween.custom_step(1.0)

func tween_done() -> void:
	%MainMenuControl.s_CameraTweenFinished.emit()
