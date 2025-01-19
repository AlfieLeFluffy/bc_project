extends "res://scenes/interactable.gd"

var lights

func local_ready() -> void:
	lights = get_node("lights").get_children()

func interact_function(event: InputEvent) -> void:
	# Turns on/off all lights and updates frames
	if event.is_action_pressed("interact") and active:
		# Set animation frame to opposite
		$Sprite2D.frame = ($Sprite2D.frame + 1) % 2
		# Turn all the light on/off
		if lights:
			for light in lights:
				light.toggleLight()
