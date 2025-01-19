extends "res://scenes/interactable.gd"

@export var opened:bool = false
@export var locked:bool = false

@onready var state_machine = $AnimationTree["parameters/playback"]


# Local ready function for instantiated objects
func local_ready() -> void:
	state_machine.start("Start")

# Active function if no dialog detected
func interact_function() -> void:
	if locked:
		return
	
	if opened:
		opened = not opened
		$StaticBody2D/CollisionShape2D2.set_deferred("disabled",false)
		$LightOccluder2D.visible = true
		state_machine.travel("closing")
	elif not opened:
		opened = not opened
		$StaticBody2D/CollisionShape2D2.set_deferred("disabled",true)
		$LightOccluder2D.visible = false
		state_machine.travel("opening")

func toggle_lock() -> void:
	locked = not locked


"""
--- Activate/deactivate interactivity Rewrite
"""

func activate_hover() -> void:
	$Sprite2D.material.set("shader_parameter/line_thickness",1)

func deactivate_hover() -> void:
	$Sprite2D.material.set("shader_parameter/line_thickness",0)
