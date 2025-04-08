class_name TimelineSelectionButton extends Button

#region Signals
signal s_ShiftClicked(timeline: Timeline)
signal s_ForeseeClicked(timeline: Timeline)
signal s_Selected(timeline: Timeline)
#endregion

#region Exported Variables
@export_range(0.0,0.1,0.01) var buttonFadeInTimer = 0.05
@export_range(0.0,0.1,0.01) var hintsFadeInTimer = 0.05
#endregion

#region Runtime Variables
var timeline: Timeline
var active: bool = false
#endregion



"""
--- Setup Methods
"""
#region Setup Methods
func _ready() -> void:
	if not timeline:
		queue_free()
	
	text = timeline.resource.name
	$Hints.modulate = Color.TRANSPARENT
	
	if Global.currentTimeline == timeline:
		disabled = true
	
	fade_in()


func fade_in() -> void:
	modulate = Color.TRANSPARENT
	GameController.fade_to_color.call_deferred(self, Color.WHITE, buttonFadeInTimer)
#endregion



"""
--- Runtime Methods
"""
#region Signal Methods
func _on_mouse_entered() -> void:
	active = true
	if not disabled:
		grab_focus()
	if timeline:
		s_Selected.emit(timeline)
	if not Global.currentTimeline == timeline:
		GameController.fade_to_color.call_deferred($Hints, Color.WHITE, hintsFadeInTimer)

func _on_mouse_exited() -> void:
	active = false
	release_focus()
	if Global.currentTimeline:
		s_Selected.emit(Global.currentTimeline)
	if not Global.currentTimeline == timeline:
		GameController.fade_to_color.call_deferred($Hints, Color.TRANSPARENT, hintsFadeInTimer)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and active and pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			s_ShiftClicked.emit(timeline)
		if event.button_index == MOUSE_BUTTON_RIGHT:
			s_ForeseeClicked.emit(timeline)
#endregion
