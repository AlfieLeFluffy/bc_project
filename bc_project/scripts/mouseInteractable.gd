extends Node2D

var SpritePtr
var LabelPtr
var Parent


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SpritePtr = get_node("Sprite2D")
	LabelPtr = get_node("Label")
	
	LabelPtr.text = get_meta("Name") + " - " + get_meta("Timeline")
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	SpritePtr.material.set("shader_parameter/line_thickness",1)
	LabelPtr.visible = 1
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	SpritePtr.material.set("shader_parameter/line_thickness",0)
	LabelPtr.visible = 0
	pass # Replace with function body.
