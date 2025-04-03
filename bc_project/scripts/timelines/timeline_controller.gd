class_name TimelineController extends Node

const preloadTimelineForesee = preload("res://scripts/timelines/foresee/timeline_foresee.tscn")

@export var current: Timeline
@export var timelines: Array[Timeline]
var timelinesDictionary: Dictionary
var timelineForesee: TimelineForesee

func _ready() -> void:
	setup_timelines_dictionary()
	
	if not current and timelines.size() > 0:
		current = timelines.get(0)
	
	for timeline in timelines:
		timeline.set_active(false)
	
	current.set_active(true)
	update_timeline_info(current)

func setup_timelines_dictionary() -> void:
	for timeline in timelines:
		timelinesDictionary[timeline.resource.name] = timeline

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("timeline_shift") and Global.TimelineShiftReady:
		shift()
	if event.is_action_pressed("timeline_foresee"):
		start_foresee()
	if event.is_action_released("timeline_foresee"):
		end_foresee()
		
		
func shift() -> void:
	if not timelinesDictionary.has(current.resource.next):
		return
	
	if timelineForesee:
		timelineForesee.queue_free()
	var destination: Timeline = timelinesDictionary[current.resource.next]
	Signals.timeline_shift.emit()
	GameController.emit_signal("playScreenEffect",GameController.screenEffectEnum.TIMELINE_SHIFT)
	update_timeline_info(destination)
	move_player(current, destination)
	move_camera_controls(current, destination)
	current.set_active(false)
	destination.set_active(true)
	current = destination
	shift_timeout()

func start_foresee() -> void:
	if not timelineForesee:
		timelineForesee = preloadTimelineForesee.instantiate()
	timelineForesee.from = current
	timelineForesee.to = timelinesDictionary[current.resource.next]
	if not timelineForesee.get_parent():
		add_child(timelineForesee)
	if not timelineForesee.visible:
		timelineForesee.visible = true

func end_foresee() -> void:
	if timelineForesee:
		timelineForesee.visible = false

func move_player(start: Timeline, end: Timeline) -> void:
	var player: Player = get_tree().get_first_node_in_group("Player")
	var timelinePosition: Vector2 = start.to_local(player.position)
	player.global_position = end.to_global(timelinePosition)

func move_camera_controls(start: Timeline, end: Timeline) -> void:
	var cameraControls: CameraControls = get_tree().get_first_node_in_group("CameraControls")
	var timelinePosition: Vector2 = start.to_local(cameraControls.position)
	cameraControls.set_camera_global_position(end.to_global(timelinePosition))

func shift_timeout() -> void:
	Global.TimelineShiftReady = false
	await get_tree().create_timer(Global.TIMELINE_TIMEOUT).timeout
	Global.TimelineShiftReady = true

func update_timeline_info(timeline: Timeline) -> void:
	Global.Timeline = timeline.resource.name
	Signals.update_overlay.emit()
