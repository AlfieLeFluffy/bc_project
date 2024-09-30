extends Node2D

var SpritePtr
var LabelBG
var Parent
var Player

var InteractKeyBG
var keyLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	InteractKeyBG = get_node("LabelBG/InteractKeyBG")
	keyLabel = get_node("LabelBG/InteractKeyBG/Label")
	SpritePtr = get_node("Sprite2D")
	LabelBG = get_node("LabelBG")
	Player = get_tree().get_current_scene().get_node("player")
	
	LabelBG.get_node("Label").text = get_meta("Name")
	keyLabel.text = InputMap.action_get_events("interact")[0].as_text()[0].to_upper()
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	SpritePtr.material.set("shader_parameter/line_thickness",1)
	LabelBG.visible = 1
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	SpritePtr.material.set("shader_parameter/line_thickness",0)
	LabelBG.visible = 0
	pass # Replace with function body.


func _on_area_entered(area: Area2D) -> void:
	if area.name == "interactRadius":
		InteractKeyBG.visible = 1
		

func _on_area_exited(area: Area2D) -> void:
	if area.name == "interactRadius":
		InteractKeyBG.visible = 0
