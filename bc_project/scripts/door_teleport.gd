extends Area2D

var interactiveLabelBG
var keyLabel
var playerInReach
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerInReach = 0
	interactiveLabelBG = get_node("InteractKeyBG")
	keyLabel = get_node("InteractKeyBG/Label")
	keyLabel.text = InputMap.action_get_events("interact")[0].as_text()[0].to_upper()
	interactiveLabelBG.visible = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and playerInReach:
		player.visible = 0
		await get_tree().create_timer(0.1).timeout
		player.position = get_meta("TeleportPosition")
		player.visible = 1


func _on_body_entered(body: Node2D) -> void:
	if body.name == get_meta("EnterNodeName"):
		player = body
		playerInReach = 1
		interactiveLabelBG.visible = 1


func _on_body_exited(body: Node2D) -> void:
	if body.name == get_meta("EnterNodeName"):
		playerInReach = 0
		interactiveLabelBG.visible = 0
