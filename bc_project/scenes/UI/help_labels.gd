extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.connect('help_text_toggle', toggle_help)

func toggle_help(type,direction) -> void:
	match type:
		"interactive":
			$InteractiveLabel.visible = direction
			$AddToBoardLabel.visible = direction
		"deleteElement":
			$DeleteElementLabel.visible = direction
		"door":
			$DoorLabel.visible = direction
