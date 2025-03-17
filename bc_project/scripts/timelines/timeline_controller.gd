class_name TimelineController extends Node

@export var current: Timeline
@export var timelines: Array[Timeline]
var timelinesDictionary: Dictionary

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
	if current and event.is_action_pressed("timeline_shift") and Global.TimelineShiftReady:
		shift()
		
func shift() -> void:
	if timelinesDictionary.has(current.resource.next):
		await get_tree().create_timer(Global.TIMELINE_SHIFT_OFFSET).timeout
		var destination: Timeline = timelinesDictionary[current.resource.next]
		Signals.timeline_shift.emit()
		update_timeline_info(destination)
		move_player(current, destination)
		move_camera_controls(current, destination)
		current.set_active(false)
		destination.set_active(true)
		current = destination
		shift_timeout()

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
