extends Control

"""
--- Runtime Variables
"""

var shiftTimeout = true

@onready var MainInfo = $MainInfo
@onready var TimelineInfo = $MainInfo/TimelineInfo
@onready var CaseInfo = $MainInfo/CaseInfo
@onready var TimelineShiftAnimation = $MainInfo/TimelineInfo/TimelineShiftAnimation

"""
--- Setup Methods
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_UI()
	Signals.connect("update_overlay", update_UI)
	Signals.connect("timeline_shift",shift_sequence)

"""
--- Runtime Methods
"""
func _process(delta: float) -> void:
	pass

"""
--- UI methods Methods
"""
func update_UI (Timeline: String = "") -> void:
	if Timeline != "":
		TimelineInfo.get_node("Label").text = tr("TIMELINE_UI") + Timeline
	else:
		TimelineInfo.get_node("Label").text = tr("TIMELINE_UI") + Global.Timeline
	TimelineShiftAnimation.get_node("Label").text = GameController.get_input_key("timeline_shift")
	
	#CaseInfo.get_node("Lable").text = "Case: " + Global.Case

"""
--- Timeline shit Methods
"""
func shift_sequence() -> void:
	TimelineShiftAnimation.play("timeout")
	GameController.emit_signal("playScreenEffect",GameController.screenEffectEnum.TIMELINE_SHIFT)
	shift_timeout_counter()

func shift_timeout_counter() -> void:
	shiftTimeout = false
	await get_tree().create_timer(Global.TIMELINE_TIMEOUT).timeout
	shiftTimeout = true
