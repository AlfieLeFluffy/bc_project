extends "res://scenes/interactable.gd"

var Lights

func LocalReady() -> void:
	Lights = get_node("lights").get_children()

	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and IsActive:
		$AnimatedSprite2D.frame = ($AnimatedSprite2D.frame + 1) % 2
		for light in Lights:
			light.toggleLight()
