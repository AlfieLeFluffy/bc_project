class_name DoorSideways extends Interactable

@export_category("Door Information")
@export var opened:bool = false
var openedCollision: bool = false
@export var locked:bool = false
@export var inverted:bool = false

@export var collisionChange: Vector2 = Vector2(18.0,0.0)

@onready var state_machine: AnimationNodeStateMachinePlayback= %AnimationTree["parameters/playback"]

# Local ready function for instantiated objects
func _local_ready(startup:bool = true) -> void:
	if not Signals.s_OpenDoor.is_connected(toggle_lock):
		Signals.s_OpenDoor.connect(toggle_lock)
	
	if not Signals.s_CloseDoor.is_connected(set_lock):
		Signals.s_CloseDoor.connect(set_lock)
	
	if not Signals.s_ToggleDoorLock.is_connected(toggle_lock_id):
		Signals.s_ToggleDoorLock.connect(toggle_lock_id)
	
	if not Signals.s_SetDoorLock.is_connected(set_lock_id):
		Signals.s_SetDoorLock.connect(set_lock_id)
	
	if opened:
		state_machine.start("open")
	else:
		state_machine.start("closed")
	
	if inverted and startup:
		$Sprite2D.scale.x = -1
		$Sprite2D.position.x = $Sprite2D.position.x * -1

func _local_process(delta: float):
	pass

# Active function if no dialog detected
func _interact_function(event: InputEvent) -> void:
	if locked:
		return
	
	opened = not opened
	update_door()

func update_door() -> void:
	state_machine.travel(["closing","opening"][int(opened)])
	%StaticCollision.set_deferred("process_mode",[Node.PROCESS_MODE_INHERIT,Node.PROCESS_MODE_DISABLED][int(opened)])
	
	update_collision_shape()
	await get_tree().create_timer(0.15).timeout
	%ClosedOccluder.visible = not opened

func update_collision_shape() -> void:
	if openedCollision and opened or not openedCollision and not opened:
		return
	
	var change: int = -1
	if opened:
		change = 1
	var invert: int = 1
	if inverted:
		invert = -1
	
	%CollisionShape2D.shape.size += collisionChange * change
	%CollisionShape2D.position += (collisionChange - Vector2(5.0,0.0)) * (change * -1) * invert
	openedCollision = opened


func open_door(id: String) -> void:
	if name == id:
		opened = true
		update_door()

func close_door(id: String) -> void:
	if name == id:
		opened = false
		update_door()

func toggle_lock() -> void:
	locked = not locked

func set_lock(state: bool = false) -> void:
	locked = state

func toggle_lock_id(id: String) -> void:
	if name == id:
		locked = not locked

func set_lock_id(id: String, state: bool = false) -> void:
	if name == id:
		locked = state

"""
--- Activate/deactivate interactivity Rewrite
"""

func activate_hover() -> void:
	material.set("shader_parameter/line_thickness",1)

func deactivate_hover() -> void:
	material.set("shader_parameter/line_thickness",0)


func activate_interactivity() -> void:
	Global.Active_Interactive_Item = self
	Signals.s_InputHelpSet.emit(GameController.get_input_key_list("interact"),"OPEN_INPUT_HELP")

func deactivate_interactivity() -> void:
	Global.Active_Interactive_Item = null
	Signals.s_InputHelpFree.emit("OPEN_INPUT_HELP")

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
		_local_ready(false)
		return true
	return false
