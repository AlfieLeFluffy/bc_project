extends "res://scenes/interactable.gd"

@export_category("Door Information")
@export var opened:bool = false
@export var locked:bool = false
@export var inverted:bool = false

@onready var state_machine = $AnimationTree["parameters/playback"]


# Local ready function for instantiated objects
func local_ready() -> void:
	if opened:
		state_machine.start("open")
	else:
		state_machine.start("closed")
		$CollisionShape2D2.disabled = true
	
	if inverted:
		$Sprite2D.scale.x = -1
		$Sprite2D.position.x = $Sprite2D.position.x * -1
		$CollisionShape2D2.position.x = $CollisionShape2D2.position.x * -1

# Active function if no dialog detected
func interact_function(event: InputEvent) -> void:
	if locked:
		return
	
	if opened:
		opened = not opened
		state_machine.travel("closing")
		$StaticBody2D/CollisionShape2D.set_deferred("disabled",false)
		$LightOccluder2D.visible = true
		$CollisionShape2D2.disabled = true
	elif not opened:
		opened = not opened
		state_machine.travel("opening")
		$StaticBody2D/CollisionShape2D.set_deferred("disabled",true)
		$LightOccluder2D.visible = false
		$CollisionShape2D2.disabled = false

func toggle_lock() -> void:
	locked = not locked

"""
--- Activate/deactivate interactivity Rewrite
"""

func activate_hover() -> void:
	$Sprite2D.material.set("shader_parameter/line_thickness",1)

func deactivate_hover() -> void:
	$Sprite2D.material.set("shader_parameter/line_thickness",0)
