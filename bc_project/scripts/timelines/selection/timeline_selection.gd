class_name TimelineSelection extends Control

#region Constants
const preloadTimelineSelectionButton = preload("res://scripts/timelines/selection/prefab/timeline_selection_button.tscn")
#endregion

#region Exported Variables
var baseTimeScale: float
@export_range(0.0,1.0,0.01) var selectionTimeScale: float = 0.1

@export_range(0.0,1.0,0.01) var backgroundFadeInTimer: float = 0.1

@export var timelineControler: TimelineController 
#endregion

#region Runtime Variables
var buttons: Array[TimelineSelectionButton]
#endregion



"""
--- Setup Methods
"""
#region Setup Methods
func _ready() -> void:
	visible = false
	%Background.modulate = Color.TRANSPARENT
	self.visibility_changed.connect(on_visibility_changed)

func setup_menu() -> void:
	for button in buttons:
		if button:
			button.queue_free()
	
	for timeline: Timeline in timelineControler.timelines:
		var button: TimelineSelectionButton = preloadTimelineSelectionButton.instantiate()
		button.timeline = timeline
		button.s_Selected.connect(button_selected)
		button.s_ShiftClicked.connect(button_pressed_shift)
		button.s_ForeseeClicked.connect(button_pressed_foresee)
		buttons.append(button)
		%Buttons.add_child(button)

func background_fade_in() -> void:
	%Background.modulate = Color.TRANSPARENT
	GameController.fade_to_color.call_deferred(%Background,Color.WHITE,backgroundFadeInTimer)

#endregion



"""
--- Setup Methods
"""
#region Signal Methods
func on_visibility_changed() -> void:
	if visible:
		background_fade_in()
		setup_menu()
		baseTimeScale = Engine.time_scale
		Engine.time_scale = selectionTimeScale
	else:
		Engine.time_scale = baseTimeScale

func button_pressed_shift(timeline: Timeline):
	timelineControler.end_selection_shift(timeline)

func button_pressed_foresee(timeline: Timeline):
	timelineControler.end_selection_foresee(timeline)

func button_selected(timeline: Timeline) -> void:
	timelineControler.selectedTimeline = timeline
#endregion
