extends Node

"""
--- Dialogue Variables
"""

var dict: Dictionary = {}

"""
--- Setup Methods
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Added group tag for persistence purposes
	add_to_group("Persistent")

"""
--- Persistence Methods
"""
func saving() -> Dictionary:
	var output: Dictionary ={
		"persistent": true,
		"nodepath": get_path(),
		"parent": get_parent().get_path(),
		"dict": dict
	}
	return output

func loading(input: Dictionary) -> bool:
	if input.has("dic"):
		dict = input["dict"]
		return true
	return false
