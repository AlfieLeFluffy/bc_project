extends "res://scenes/interactable.gd"

"""
--- Runtime Variables
"""
var lights

@export_category("Setup Variables")
@export var state: bool = true 

"""
--- Setup Methods
"""
func local_ready() -> void:
	lights = get_node("lights").get_children()
	
	if not state:
		set_lights(state)

"""
--- Interact Methods
"""
func interact_function(event: InputEvent) -> void:
	# Set animation frame to opposite
	$Sprite2D.frame = ($Sprite2D.frame + 1) % 2
	# Inverts state for persistence
	state = not state
	# Toggles all lights
	set_lights(state)

func set_lights(newState: bool) -> void:
	# Turn all the light on/off
	if lights:
		for light in lights:
			light.set_state(newState)

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
