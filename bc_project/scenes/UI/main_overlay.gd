extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UpdateUI()

func UpdateUI () -> void:
	$MarginContainer/HBoxContainer/VBoxContainer/TimelineUI/Label.text = "Timeline: " + Global.Timeline
	$MarginContainer/HBoxContainer/VBoxContainer/CaseUI/Label.text = "Case: " + Global.Case
	$MarginContainer/HBoxContainer/VBoxContainer/TableTab/Label.text = InputMap.action_get_events("table_toggle")[0].as_text().split("(")[0]
