class_name StateMachine extends Node

"""
--- State Variables
"""

var currentState: State
var states: Dictionary = {}

"""
--- Exported State Variables
"""

@export_group("State Machine Setup")
@export var initialState: State

"""
--- Setup Functions
"""

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transition.connect(on_child_transition)

	if initialState:
		currentState = initialState
		currentState.Enter()
	else:
		if states[0]:
			currentState = states[0]
			currentState.Enter()

"""
--- Runtime Functions
"""

func _process(delta: float) -> void:
	if currentState:
		currentState.Process(delta)

func _physics_process(delta: float) -> void:
	if currentState:
		currentState.Physics_Process(delta)

"""
--- State Transition Functions
"""

func on_child_transition(state, new_state_name) -> void:
	if state != currentState:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if not new_state:
		return
	
	if currentState:
		currentState.Exit()
	
	currentState = new_state
	currentState.Enter()
