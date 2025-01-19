extends "res://scenes/interactable.gd"

@export var opened:bool = false
@export var locked:bool = false

# Active function if no dialog detected
func interact_function() -> void:
	if locked:
		return
	
	if opened:
		opened = not opened
		$StaticBody2D/CollisionShape2D2.set_deferred("disabled",false)
		$LightOccluder2D.visible = true
	elif not opened:
		opened = not opened
		$StaticBody2D/CollisionShape2D2.set_deferred("disabled",true)
		$LightOccluder2D.visible = false

func toggle_lock() -> void:
	locked = not locked
