extends VBoxContainer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.connect('help_text_toggle', toggle_help)

func toggle_help(type,direction) -> void:
	match type:
		Global.help_signal_type.interactive:
			$InteractiveLabel.visible = direction
			$AddToBoardLabel.visible = direction
		Global.help_signal_type.deleteElement:
			$DeleteElementLabel.visible = direction
		Global.help_signal_type.door:
			$DoorLabel.visible = direction
