extends "res://scenes/interactable.gd"

var player

@export var otherDoor: Node

# Local ready function for instantiated objects
func local_ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

# Active function if no dialog detected
func interact_function(event: InputEvent) -> void:
	player.visible = false
	await get_tree().create_timer(0.1).timeout
	player.position = otherDoor.global_position
	player.visible = true

func activate_interactivity() -> void:
	Global.Active_Interactive_Item = self
	Signals.emit_signal("help_text_toggle",Global.help_signal_type.DOOR,true)

func deactivate_interactivity() -> void:
	Global.Active_Interactive_Item = null
	Signals.emit_signal("help_text_toggle",Global.help_signal_type.DOOR,false)
