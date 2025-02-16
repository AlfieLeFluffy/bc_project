extends CanvasLayer

"""
--- Runtime Variables
"""
var shiftTimeout = true

"""
--- Setup Methods
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UpdateUI()
	$".".visible = true
	$ScreenEffectContainer/TextureRect.texture.current_frame = 7

"""
--- Runtime Methods
"""
func _process(delta: float) -> void:
	if not Global.TimelineShiftReady and shiftTimeout:
		$Overlay/Collums/LeftUI/TimelineUI/InteractKeyBG.play("timeout")
		$ScreenEffectContainer/TextureRect.texture.current_frame = 0
		TimeoutFlag()


func UpdateUI () -> void:
	$Overlay/Collums/LeftUI/TimelineUI/Label.text = "Timeline: " + Global.Timeline
	$Overlay/Collums/LeftUI/CaseUI/Label.text = "Case: " + Global.Case
	$Overlay/Collums/LeftUI/TimelineUI/InteractKeyBG/Label.text = GameController.get_input_key("timeline_shift")

func TimeoutFlag() -> void:
	shiftTimeout = false
	await get_tree().create_timer(Global.TIMELINE_TIMEOUT).timeout
	shiftTimeout = true
