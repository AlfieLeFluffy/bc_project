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
	return dict

func loading(input: Dictionary) -> bool:
	if input.has("DialogVariables"):
		dict = input["DialogVariables"]
		return true
	return false
