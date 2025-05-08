class_name TimelineController extends Node


#region Preloaded Scenes Constants
## A constant containing a preloaded scene of [TimelineForesight]
const preloaded_TimelineForesee = preload("res://scripts/timelines/foresee/timeline_foresee.tscn")
## A constant containing a preloaded scene of [TimelineSelection]
const preloaded_TimelineSelection = preload("res://scripts/timelines/selection/timeline_selection.tscn")
#endregion

#region Scene Instance Variables
## A variable holding the [TimelineForesee] scene instance
var timelineForesee: TimelineForesee
## A variable holding the [TimelineSelection] scene instance
var timelineSelection: TimelineSelection
#endregion

#region Runtime and Exported Variables
@export_category("Timeline Setup Variables")
## A variable that flags if the timeline controls should work or not.
@export var active: bool = true
## A variable containing the current [Timeline]
@export var current: Timeline
## A variable containing an array of all possible [Timeline]s
@export var timelines: Array[Timeline]
## A variable containing a dictionary mirror of all [param timelines]
var timelinesDictionary: Dictionary
## A variable containing the currently selected [Timeline]
var selectedTimeline: Timeline

@export_category("Timeline Shift Variables")
## An exported variable containing the time necessary to hold down the selection key for the [TimelineSelection]
## menu to popup.
@export_range(0.0,2.0,0.1) var selectionTimeout: float = 0.3
## A variable used as flag to find out if the timeline shift input key is held down
var timelineShiftKeyDown: bool = false
## A variable used figure out how long was the timeline shift input key held down for
var timelineShiftPressedDelta: float = 0.0
#endregion

"""
--- Setup Methods
"""
#region Setup Methods
func _ready() -> void:
	setup_timelines_dictionary()
	
	if not current and timelines.size() > 0:
		current = timelines.get(0)
	
	for timeline in timelines:
		timeline.set_active(false)
	
	current.set_active(true)
	update_timeline_info(current)
	Signals.s_ShiftToTimeline.connect(shift_to_timeline_id)
	Signals.s_SetTimelineControllerActive.connect(set_timeline_controller_active)
	PersistenceController.s_SceneLoaded.connect(setup_timeline_selection)

func setup_timelines_dictionary() -> void:
	for timeline in timelines:
		timelinesDictionary[timeline.resource.name] = timeline

func setup_timeline_selection() -> void:
	timelineSelection = preloaded_TimelineSelection.instantiate()
	if GameController.mainOverlay:
		timelineSelection.timelineControler = self
		GameController.mainOverlay.add_child(timelineSelection)
#endregion



"""
--- Runtime Methods
"""
#region Runtime Methods
func _process(delta: float) -> void:
	if timelineShiftKeyDown:
		timelineShiftPressedDelta += delta
	elif not timelineShiftKeyDown: 
		timelineShiftPressedDelta = 0.0
		timelineSelection.visible = false
	
	if timelineShiftPressedDelta > selectionTimeout:
		timelineSelection.visible = true

func _unhandled_input(event: InputEvent) -> void:
	if not active and (event.is_action_pressed("timeline_shift") or event.is_action_pressed("timeline_foresight")):
		GameController.play_quick_text_effect_default("TIMELINE_DEVICE_OFF_HINT")
		return
	if event.is_action_pressed("timeline_shift"):
		selectedTimeline = timelinesDictionary[current.resource.next]
		timelineShiftKeyDown = true
	elif event.is_action_released("timeline_shift"):
		if timelineShiftKeyDown:
			shift(selectedTimeline)
		timelineShiftKeyDown = false
	if event.is_action_pressed("timeline_foresight"):
		selectedTimeline = timelinesDictionary[current.resource.next]
		start_foresee(selectedTimeline)
	elif event.is_action_released("timeline_foresight"):
		end_foresee()

func set_timeline_controller_active(state: bool) -> void:
	active = state
	update_timeline_info(current)
#endregion



#region Selection End Methods
## A method called when selection ends with a timeline shift [br]
##
## - [param _destination] is the selected [Timeline]. [br]
func end_selection_shift(_destination: Timeline) -> void:
	selectedTimeline = _destination
	if timelineShiftKeyDown:
		shift(selectedTimeline)
	timelineShiftKeyDown = false

## A method called when selection ends with a timeline foresight [br]
##
## - [param _destination] is the selected [Timeline]. [br]
func end_selection_foresee(_destination: Timeline) -> void:
	selectedTimeline = _destination
	if timelineShiftKeyDown:
		start_foresee(selectedTimeline)
	timelineShiftKeyDown = false
#endregion



#region Timeline Shift Methods
## A method that calls for a timeline shift with a specific timeline id/name. [br]
##
## - [param id] is the id/name of the target [Timeline]. [br]
func shift_to_timeline_id(id: String):
	if timelinesDictionary.has(id):
		shift(timelinesDictionary[id])

## A method that goes through the entire timeline shift sequence. [br]
##
## - [param _destination] is the selected [Timeline]. [br]
func shift(_destination: Timeline) -> void:
	if not _destination:
		return
	
	if current == _destination:
		return
	
	if timelineForesee:
		end_foresee()
	
	Signals.s_TimelineShift.emit()
	GameController.emit_signal("s_ScreenEffectPlay",GameController.e_ScreenEffectType.TIMELINE_SHIFT)
	update_timeline_info(_destination)
	move_player(current, _destination)
	move_camera_controls(current, _destination)
	current.set_active(false)
	_destination.set_active(true)
	current = _destination

## A method that moves the player character from one timeline to another. [br]
##
## - [param start] is the current [Timeline]. [br]
## - [param end] is the target [Timeline]. [br]
func move_player(start: Timeline, end: Timeline) -> void:
	var player: Player = get_tree().get_first_node_in_group("Player")
	var timelinePosition: Vector2 = start.to_local(player.position)
	player.global_position = end.to_global(timelinePosition)

## A method that moves the camera and camera controls from one timeline to another. [br]
##
## - [param start] is the current [Timeline]. [br]
## - [param end] is the target [Timeline]. [br]
func move_camera_controls(start: Timeline, end: Timeline) -> void:
	var cameraControls: CameraControls = get_tree().get_first_node_in_group("CameraControls")
	var timelinePosition: Vector2 = start.to_local(cameraControls.position)
	cameraControls.set_camera_global_position(end.to_global(timelinePosition))

## A method that updates timeline informations.
func update_timeline_info(timeline: Timeline) -> void:
	Global.currentTimeline = timeline
	Signals.s_UpdateMainOverlay.emit()
	Signals.s_SetMainOverlayTimeline.emit(active)
#endregion



#region Foresight Methods
## A method that starts the timeline foresight.[br]
##
## - [param _destination] is the selected [Timeline]. [br]
func start_foresee(_destination: Timeline) -> void:
	if current.name == _destination.name:
		return
	
	if not timelineForesee:
		timelineForesee = preloaded_TimelineForesee.instantiate()
	
	timelineForesee.from = current
	timelineForesee.to = _destination
	
	if timelineForesee.get_parent() != self:
		add_child(timelineForesee)
	timelineForesee.visible = true

## A method that ends any current timeline foresight.
func end_foresee() -> void:
	if timelineForesee:
		timelineForesee.visible = false
#endregion
