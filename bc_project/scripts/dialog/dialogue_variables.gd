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
	add_to_group(PersistenceController.PERSISTENCE_GLOBAL_GROUP_NAME)

func check_variable(variable: String):
	if variables.has(variable):
		return true
	return false


func get_variable(variable: String):
	if not variables.has(variable):
		return null
	return variables[variable]


func check_variables(array: Array):
	for variable in array:
		if not variables.has(variable):
			return false
	return true

func set_variable(variable: String, value):
	variables[variable] = value

func clear_variables():
	variables.clear()
	
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
	variables.clear()
	if input.has("variables"):
		variables = input["variables"]
		return true
	return false
