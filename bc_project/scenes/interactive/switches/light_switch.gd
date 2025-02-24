extends "res://scenes/interactive/interactable.gd"

"""
--- Setup Exported Variables
"""
@export_category("Setup Variables")
@export var circuit: int = 0 
@export var state: bool = true 

"""
--- Setup Methods
"""
func local_ready() -> void:
	pass

"""
--- Interact Methods
"""
func interact_function(event: InputEvent) -> void:
	# Set animation frame to opposite
	$Sprite2D.frame = ($Sprite2D.frame + 1) % 2
	# Inverts state for persistence
	state = not state
	# Toggles all lights
	Signals.emit_signal("set_light",circuit,state)

func set_lights(newState: bool) -> void:
	Signals.emit_signal("set_light",circuit,newState)

"""
--- Persistence Methods
"""
func saving() -> Dictionary:
	var output: Dictionary = {
		"persistent": true,
		"nodepath": get_path(),
		"parent": get_parent().get_path(),
		"state": state,
	}
	return output

func loading(input: Dictionary) -> bool:
	if input.has("state"):
		state = input["state"]
		local_ready()
		return true
	return false
