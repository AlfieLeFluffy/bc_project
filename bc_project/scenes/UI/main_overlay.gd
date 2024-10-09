extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UpdateUI()

func UpdateUI () -> void:
	$MarginContainer/TextureRect/Label.text = " Timeline: " + Global.Timeline
