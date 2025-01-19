class_name TimelineState extends State

@export_category("Timeline Information")
@export var nextTimeline: String

var activeTimeline: bool
var timelineSpace: Node2D

func _ready() -> void:
	activeTimeline = false
	if not get_children().is_empty():
		timelineSpace = get_children()[0]

func Enter() -> void:
	if timelineSpace:
		activeTimeline = true
		timelineSpace.visible = true

func Exit() -> void:
	if timelineSpace:
		activeTimeline = false
		timelineSpace.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if activeTimeline and event.is_action_pressed("timeline_shift") and Global.TimelineShiftReady:
		TimelineTimeout()
		Transition.emit(self,nextTimeline)

func Process(delta: float) -> void:
	pass

func Physics_Process(delta: float) -> void:
	pass

func TimelineTimeout() -> void:
	Global.TimelineShiftReady = false
	await get_tree().create_timer(Global.TIMELINE_TIMEOUT).timeout
	Global.TimelineShiftReady = true

func UpdateTimeline() -> void:
	Global.Timeline = get_child(0).name
	Signals.emit_signal("update_overlay")
