extends Area2D

var playerInReach 
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerInReach = 0
	player = get_tree().get_current_scene().get_node("player")
	
	$InteractKeyBG/Label.text = InputMap.action_get_events("interact")[0].as_text()[0].to_upper()
	$InteractKeyBG.visible = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.get_meta("InteractItemSet"):
		$InteractKeyBG/stopSign.visible = 1
	else:
		$InteractKeyBG/stopSign.visible = 0		

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and playerInReach and not player.get_meta("InteractItemSet"):
		player.visible = 0
		await get_tree().create_timer(0.1).timeout
		player.position = get_meta("TeleportPosition")
		player.visible = 1


func _on_body_entered(body: Node2D) -> void:
	if body.name == get_meta("EnterNodeName"):
		playerInReach = 1
		$InteractKeyBG.visible = 1


func _on_body_exited(body: Node2D) -> void:
	if body.name == get_meta("EnterNodeName"):
		playerInReach = 0
		$InteractKeyBG.visible = 0
