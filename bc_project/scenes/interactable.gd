extends Node2D

var Sprite

var InteractKeyBG
var keyLabel
var LabelBG

var Parent
var Player
var IsActive


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Sprite = get_node("AnimatedSprite2D")
	
	InteractKeyBG = get_node("LabelBG/InteractKeyBG")
	keyLabel = get_node("LabelBG/InteractKeyBG/Label")
	keyLabel.text = InputMap.action_get_events("interact")[0].as_text()[0].to_upper()
	
	LabelBG = get_node("LabelBG")
	LabelBG.get_node("Label").text = get_meta("Name")
	
	Player = get_tree().get_current_scene().get_node("player")
	IsActive = false
	
	LocalReady()

# Local ready function for instantiated objects
func LocalReady() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if LabelBG.visible == true and InteractKeyBG.visible == true:
		IsActive = true
	else:
		IsActive = false

func _on_mouse_entered() -> void:
	Sprite.material.set("shader_parameter/line_thickness",1)
	LabelBG.visible = true
	Player.set_meta("InteractItemSet",1)


func _on_mouse_exited() -> void:
	Sprite.material.set("shader_parameter/line_thickness",0)
	LabelBG.visible = false
	Player.set_meta("InteractItemSet",0)


func _on_area_entered(area: Area2D) -> void:
	if area.name == "interactRadius":
		InteractKeyBG.visible = true

func _on_area_exited(area: Area2D) -> void:
	if area.name == "interactRadius":
		InteractKeyBG.visible = false
