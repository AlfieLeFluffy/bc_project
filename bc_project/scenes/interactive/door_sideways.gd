extends "res://scenes/interactable.gd"

@export_category("Door Information")
@export var opened:bool = false
@export var locked:bool = false
@export var inverted:bool = false

@onready var state_machine = $AnimationTree["parameters/playback"]

var timelineSpace

# Local ready function for instantiated objects
func local_ready(startup:bool = true) -> void:
	timelineSpace = get_parent().get_parent()
	
	if opened:
		state_machine.start("open")
	else:
		state_machine.start("closed")
		$CollisionShape2D2.disabled = true
	
	if inverted and startup:
		$Sprite2D.scale.x = -1
		$Sprite2D.position.x = $Sprite2D.position.x * -1
		$CollisionShape2D2.position.x = $CollisionShape2D2.position.x * -1

func local_process(delta: float):
	if not timelineSpace.visible and not $StaticBody2D/CollisionShape2D.disabled:
		$StaticBody2D/CollisionShape2D.set_deferred("disabled",true)
	elif timelineSpace.visible and not opened and $StaticBody2D/CollisionShape2D.disabled:
		$StaticBody2D/CollisionShape2D.set_deferred("disabled",false)
	elif timelineSpace.visible and opened and $StaticBody2D/CollisionShape2D.disabled:
		$StaticBody2D/CollisionShape2D.set_deferred("disabled",true)

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


func activate_interactivity() -> void:
	Global.Active_Interactive_Item = self
	Signals.emit_signal("input_help_set",GameController.get_input_key_list("interact"),"Open")

func deactivate_interactivity() -> void:
	Global.Active_Interactive_Item = null
	Signals.emit_signal("input_help_delete","Open")

"""
--- Persistence Methods
"""
func saving() -> Dictionary:
	var output: Dictionary = {
		"persistent": true,
		"nodepath": get_path(),
		"parent": get_parent().get_path(),
		"opened": opened,
		"locked": locked
	}
	return output

func loading(input: Dictionary) -> bool:
	if input.has("opened") and input.has("locked"):
		opened = input["opened"]
		locked = input["locked"]
		local_ready(false)
		return true
	return false
