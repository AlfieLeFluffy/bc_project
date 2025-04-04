extends VBoxContainer

"""
--- Preload Scenes
"""
const preloadHelpLabel = preload("res://scenes/UI/input_help/input_help_label.tscn")

"""
--- Runtime Variables
"""
var labels: Dictionary = {}

"""
--- Setup Functions
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.connect('input_help_set', set_input_help_label)
	Signals.connect('input_help_delete', delete_input_help_label)
	
	
	set_input_help_label(GameController.get_input_key_list("timeline_shift"), "TIMELINE_SHIFT_INPUT_HELP")

"""
--- INput Help Methods
"""

func set_input_help_label(input:Array,description:String) -> void:
	if labels.has(description):
		return
	var label = preloadHelpLabel.instantiate()
	labels[description] = label
	$".".add_child(label)
	$".".move_child(label,0)
	label.set_label(input,description)

func delete_input_help_label(description:String) -> void:
	if not labels.has(description):
		return
	labels[description].queue_free()
	labels.erase(description)
