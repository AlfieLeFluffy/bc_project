extends Control

"""
--- Runtime Variables
"""

var shiftTimeout = true

"""
--- Setup Methods
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_UI()
	Signals.s_UpdateMainOverlay.connect(update_UI)
	SettingsController.s_Retranslate.connect(update_UI)

"""
--- Runtime Methods
"""
func _process(delta: float) -> void:
	pass

"""
--- UI methods Methods
"""
func update_UI (timeline: String = "") -> void:
	var timelineString: String = "" 
	if timeline != "":
		timelineString = timeline
	else:
		timelineString = Global.currentTimeline.resource.name
	
	%TimelineLabel.text = "[font_size=32][color=#%s]%s[/color][color=#%s]%s[/color]" % [Global.color_White.to_html(),tr("TIMELINE_UI"),Global.color_White.to_html(), timelineString]
	
	%TimelineKeyLabel.text = "[font_size=32][color=#%s]%s[/color]" % [Global.color_White.to_html(),GameController.get_input_key("timeline_shift")]
