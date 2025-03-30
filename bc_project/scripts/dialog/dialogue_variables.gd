class_name DialogueVaribles extends Node

"""
--- Dialogue Variables
"""

var variables: Dictionary = {}

"""
--- Setup Methods
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Added group tag for persistence purposes
	add_to_group("Persistent")

func check_variable(variable: String):
	if not variables.has(variable):
		return null
	return variables[variable]

func set_variable(variable: String, value):
	variables[variable] = value
	
"""
--- Persistence Methods
"""
func saving() -> Dictionary:
	var output: Dictionary ={
		"persistent": true,
		"nodepath": get_path(),
		"parent": get_parent().get_path(),
		"variables": variables
	}
	return output

func loading(input: Dictionary) -> bool:
	if input.has("variables"):
		variables = input["variables"]
		return true
	return false
