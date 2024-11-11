extends "res://scenes/interactable.gd"

var player

@export var otherDoor: Node

# Local ready function for instantiated objects
func LocalReady() -> void:
	player = get_tree().get_current_scene().get_node("player")

# Active function if no dialog detected
func interact_function() -> void:
	player.visible = 0
	await get_tree().create_timer(0.1).timeout
	player.position = otherDoor.global_position
	player.visible = 1

func activate_interactivity() -> void:
	$Labels.visible = true
	Global.Active_Interactive_Item = self
	Signals.emit_signal("help_text_toggle",Global.help_signal_type.door,true)

func deactivate_interactivity() -> void:
	$Labels.visible = false
	Global.Active_Interactive_Item = null
	Signals.emit_signal("help_text_toggle",Global.help_signal_type.door,false)
