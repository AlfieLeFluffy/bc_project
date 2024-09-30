extends Node2D

var SpritePtr
var LabelBG
var Parent
var Player

var InteractKeyBG
var keyLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	InteractKeyBG = get_node("InteractKeyBG")
	keyLabel = get_node("InteractKeyBG/Label")
	SpritePtr = get_node("Sprite2D")
	LabelBG = get_node("LabelBG")
	
	LabelBG.get_node("Label").text = get_meta("Name") + " - " + get_meta("Timeline")
	keyLabel.text = InputMap.action_get_events("interact")[0].as_text()[0].to_upper()
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	SpritePtr.material.set("shader_parameter/line_thickness",1)
	LabelBG.visible = 1
	InteractKeyBG.visible = 1
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	SpritePtr.material.set("shader_parameter/line_thickness",0)
	LabelBG.visible = 0
	InteractKeyBG.visible = 0
	pass # Replace with function body.
