class_name DialogueVaribles extends Node

"""
--- Dialogue Variables
"""

var vars: Dictionary = {}

"""
--- Setup Methods
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Added group tag for persistence purposes
	add_to_group("Persistent")
	Signals.connect("setup_level_dialogue_variables",setup_dialogue_variables)

func setup_dialogue_variables(variables: Dictionary) -> void:
	vars = variables

"""
--- Persistence Methods
"""
func saving() -> Dictionary:
	var output: Dictionary ={
		"persistent": true,
		"nodepath": get_path(),
		"parent": get_parent().get_path(),
		"vars": vars
	}
	return output

func loading(input: Dictionary) -> bool:
	if input.has("dic"):
		vars = input["vars"]
		return true
	return false
