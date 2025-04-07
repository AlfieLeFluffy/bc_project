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
	Signals.connect("update_overlay", update_UI)
	SettingsController.connect("retranslate", update_UI)
	Signals.connect("timeline_shift",shift_sequence)

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
		timelineString = Global.Timeline
	
	%TimelineLabel.text = "[font_size=32][color=#%s]%s[/color][color=#%s]%s[/color]" % [Global.color_White.to_html(),tr("TIMELINE_UI"),Global.color_White.to_html(), timelineString]
	
	%TimelineKeyLabel.text = "[font_size=32][color=#%s]%s[/color]" % [Global.color_White.to_html(),GameController.get_input_key("timeline_shift")]

"""
--- Timeline shit Methods
"""
func shift_sequence() -> void:
	shift_timeout_counter()

func shift_timeout_counter() -> void:
	shiftTimeout = false
	await get_tree().create_timer(Global.TIMELINE_TIMEOUT).timeout
	shiftTimeout = true
