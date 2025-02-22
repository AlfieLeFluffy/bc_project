class_name Light extends Node2D

"""
--- Setup Exported Variables
"""
@export_category("Light Setup")
@export var circuit: int = 0
@export var initialState: bool = true

"""
--- Setup Method
"""

func _ready() -> void:
	Signals.connect("set_light",set_state)
	Signals.connect("toggle_light",toggle_state)

"""
--- Override Methods
"""
func set_state(circuitSignal: int, state: bool) -> void:
	pass

func toggle_state(circuitSignal: int) -> void:
	pass
