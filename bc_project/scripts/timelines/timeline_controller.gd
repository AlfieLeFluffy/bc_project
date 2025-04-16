class_name TimelineController extends Node

const preloadTimelineForesee = preload("res://scripts/timelines/foresee/timeline_foresee.tscn")
const preloadTimelineSelection = preload("res://scripts/timelines/selection/timeline_selection.tscn")

var timelineForesee: TimelineForesee
var timelineSelection: TimelineSelection

@export_category("Timeline Setup Variables")
@export var current: Timeline
@export var timelines: Array[Timeline]
var timelinesDictionary: Dictionary

var selectedTimeline: Timeline

@export_category("Timeline Shift Variables")
@export_range(0.0,2.0,0.1) var selectionTimeout: float = 0.3
var timelineShiftKeyDown: bool = false
var timelineShiftPressedDelta: float = 0.0

func _ready() -> void:
	setup_timelines_dictionary()
	
	if not current and timelines.size() > 0:
		current = timelines.get(0)
	
	for timeline in timelines:
		timeline.set_active(false)
	
	current.set_active(true)
	update_timeline_info(current)
	GameController.s_SceneLoaded.connect(setup_timeline_selection)

func setup_timelines_dictionary() -> void:
	for timeline in timelines:
		timelinesDictionary[timeline.resource.name] = timeline

func setup_timeline_selection() -> void:
	timelineSelection = preloadTimelineSelection.instantiate()
	await GameController.mainOverlay
	if GameController.mainOverlay:
		timelineSelection.timelineControler = self
		GameController.mainOverlay.add_child(timelineSelection)

func _process(delta: float) -> void:
	if timelineShiftKeyDown:
		timelineShiftPressedDelta += delta
	elif not timelineShiftKeyDown: 
		timelineShiftPressedDelta = 0.0
		timelineSelection.visible = false
	
	if timelineShiftPressedDelta > selectionTimeout:
		timelineSelection.visible = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("timeline_shift"):
		selectedTimeline = timelinesDictionary[current.resource.next]
		timelineShiftKeyDown = true
	elif event.is_action_released("timeline_shift"):
		if timelineShiftKeyDown:
			shift(selectedTimeline)
		timelineShiftKeyDown = false
	if event.is_action_pressed("timeline_foresee"):
		selectedTimeline = timelinesDictionary[current.resource.next]
		start_foresee(selectedTimeline)
	elif event.is_action_released("timeline_foresee"):
		end_foresee()

func end_selection_shift(_destination: Timeline) -> void:
	selectedTimeline = _destination
	if timelineShiftKeyDown:
		shift(selectedTimeline)
	timelineShiftKeyDown = false

func end_selection_foresee(_destination: Timeline) -> void:
	selectedTimeline = _destination
	if timelineShiftKeyDown:
		start_foresee(selectedTimeline)
	timelineShiftKeyDown = false
	

func shift(_destination: Timeline) -> void:
	if not _destination:
		return
	
	if current == _destination:
		return
	
	if timelineForesee:
		end_foresee()
	
	Signals.s_TimelineShift.emit()
	GameController.emit_signal("s_ScreenEffectPlay",GameController.screenEffectType.TIMELINE_SHIFT)
	update_timeline_info(_destination)
	move_player(current, _destination)
	move_camera_controls(current, _destination)
	current.set_active(false)
	_destination.set_active(true)
	current = _destination

func start_foresee(_destination: Timeline) -> void:
	if current.name == _destination.name:
		return
	
	if not timelineForesee:
		timelineForesee = preloadTimelineForesee.instantiate()
	
	timelineForesee.from = current
	timelineForesee.to = _destination
	
	if timelineForesee.get_parent() != self:
		add_child(timelineForesee)
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

func update_timeline_info(timeline: Timeline) -> void:
	Global.currentTimeline = timeline
	Signals.s_UpdateMainOverlay.emit()
