extends Area2D

var playerInReach 
var player
var flop = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerInReach = 0
	player = get_tree().get_current_scene().get_node("player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if playerInReach and not flop and Global.Active_Interactive_Item == null:
		flop = true
		Signals.emit_signal("help_text_toggle",Global.help_signal_type.door,true)
	elif playerInReach and flop and Global.Active_Interactive_Item != null:
		flop = false
		Signals.emit_signal("help_text_toggle",Global.help_signal_type.door,false)
	elif not playerInReach and flop:
		flop = false
		Signals.emit_signal("help_text_toggle",Global.help_signal_type.door,false)
		

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and playerInReach and Global.Active_Interactive_Item == null:
		player.visible = 0
		await get_tree().create_timer(0.1).timeout
		player.position = get_meta("TeleportPosition")
		player.visible = 1


func _on_body_entered(body: Node2D) -> void:
	if body.name == get_meta("EnterNodeName"):
		playerInReach = true


func _on_body_exited(body: Node2D) -> void:
	if body.name == get_meta("EnterNodeName"):
		playerInReach = false
