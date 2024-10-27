extends "res://scenes/interactable.gd"

var Lights

func LocalReady() -> void:
	Lights = get_node("lights").get_children()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("add_to_board") and active:
		Signals.emit_signal('create_item_element',get_sprite_from_current_frame(), get_meta("Name"),get_meta("Description"))
	elif event.is_action_pressed("interact") and active:
		$AnimatedSprite2D.frame = ($AnimatedSprite2D.frame + 1) % 2
		for light in Lights:
			light.toggleLight()
