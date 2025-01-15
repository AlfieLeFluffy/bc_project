extends VBoxContainer

"""
--- Setup Functions
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.connect('help_text_toggle', toggle_help)

"""
--- Tip Toggle Functionss
"""
func toggle_help(type,direction) -> void:
	match type:
		Global.help_signal_type.INTERACTIVE:
			$InteractiveLabel.visible = direction
			$AddToBoardLabel.visible = direction
		Global.help_signal_type.TALK:
			$TalkLabel.visible = direction
		Global.help_signal_type.DELETEELEMENT:
			$DeleteElementLabel.visible = direction
		Global.help_signal_type.DOOR:
			$DoorLabel.visible = direction
