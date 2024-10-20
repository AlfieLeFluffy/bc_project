extends CanvasLayer

var TimelineTimeoutFlag = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UpdateUI()
	$".".visible = true
	$ScreenEffectContainer/TextureRect.texture.current_frame = 7
	
func _process(delta: float) -> void:
	if not Global.TimelineShiftReady and TimelineTimeoutFlag:
		$Overlay/HBoxContainer/VBoxContainer/TimelineUI/InteractKeyBG.play("timeout")
		$ScreenEffectContainer/TextureRect.texture.current_frame = 0
		TimeoutFlag()

func UpdateUI () -> void:
	$Overlay/HBoxContainer/VBoxContainer/TimelineUI/Label.text = "Timeline: " + Global.Timeline
	$Overlay/HBoxContainer/VBoxContainer/CaseUI/Label.text = "Case: " + Global.Case
	$Overlay/HBoxContainer/VBoxContainer/TableTab/Label.text = Global.GetInputMapKey("table_toggle")
	$Overlay/HBoxContainer/VBoxContainer/TimelineUI/InteractKeyBG/Label.text = Global.GetInputMapKey("timeline_shift")



func TimeoutFlag() -> void:
	TimelineTimeoutFlag = false
	await get_tree().create_timer(Global.TIMELINE_TIMEOUT).timeout
	TimelineTimeoutFlag = true
