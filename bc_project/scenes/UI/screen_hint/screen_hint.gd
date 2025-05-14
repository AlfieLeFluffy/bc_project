class_name ScreenHint extends Control

## The input that needs to be read.
@export var hintAction: StringName = &''
const FONT_SIZE = 48

func _ready() -> void:
	if hintAction.is_empty():
		visible = false
		return
	
	setup_help()

func setup_help() -> void:
	if InputMap.has_action(hintAction):
		var key: String = GameController.get_input_key(hintAction)
		if key.is_empty():
			visible = false
			return
		%HintText.text = "[font_size=%s]%s" % [str(SettingsController.scale_font_size(FONT_SIZE)),key]
