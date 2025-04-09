class_name Light extends Node2D

"""
--- Setup Exported Variables
"""
@export_category("Light Setup")
@export var circuit: int = 0
@export var initialState: bool = true
@export var lightColor: Color
@export var lightEnergy: float

"""
--- Setup Method
"""

func _ready() -> void:
	Signals.s_SetLight.connect(set_state)
	Signals.s_ToggleLight.connect(toggle_state)
	_local_ready()

func _local_ready() -> void:
	pass

"""
--- Override Methods
"""
func set_state(circuitSignal: int, state: bool) -> void:
	pass

func toggle_state(circuitSignal: int) -> void:
	pass
