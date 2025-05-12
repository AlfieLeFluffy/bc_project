class_name ElevatorStop extends Node2D

@export var stopName: String = ""
@export var flip: bool = false
@export var active: bool = true

func _ready() -> void:
	%AutomatedDoorSprite.flip_h = flip

func set_active(state: bool) -> void:
	%DoorOcclusion.visible = not state
	%DoorCollisionShape.disabled = state
	
	var animation: String = "open"
	if state:
		animation = "closed"
	%AutomatedDoorSprite.play(animation)


#region Persistence Methods
"""
--- Persistence Methods
"""
func saving() -> Dictionary:
	var output: Dictionary = {
		"persistent": true,
		"nodepath": get_path(),
		"parent": get_parent().get_path(),
		"active": active,
	}
	return output

func loading(input: Dictionary) -> bool:
	if input.has("active"):
		active = input["active"]
		set_active(active)
	return true
#endregion
