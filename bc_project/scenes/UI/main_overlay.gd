extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UpdateUI()

func UpdateUI () -> void:
	$MarginContainer/VBoxContainer/TimelineUI/Label.text = "Timeline: " + Global.Timeline
	$MarginContainer/VBoxContainer/CaseUI/Label.text = "Case: " + Global.Case
