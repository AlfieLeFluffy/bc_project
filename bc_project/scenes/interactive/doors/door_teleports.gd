class_name DoorTeleport extends Interactable

var player

@export var otherDoor: Node

# Local ready function for instantiated objects
func _local_ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

# Active function if no dialog detected
func _interact_function(event: InputEvent) -> void:
	player.visible = false
	await get_tree().create_timer(0.1).timeout
	player.position = otherDoor.global_position
	player.visible = true

func activate_interactivity() -> void:
	Global.Active_Interactive_Item = self
	Signals.s_InputHelpSet.emit(GameController.get_input_key_list("interact"),"GO_THROUGH_DOOR_INPUT_HELP")

func deactivate_interactivity() -> void:
	Global.Active_Interactive_Item = null
	Signals.s_InputHelpFree.emit("GO_THROUGH_DOOR_INPUT_HELP")
