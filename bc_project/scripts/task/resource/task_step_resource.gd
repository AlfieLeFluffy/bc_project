class_name TaskStepResource extends Resource

@export var name: String

@export var next: Array[TaskStepResource]
@export var failed: bool = false

@export var object: String
@export var callable: String
@export var parameters: Array

func run_command(base: Node) -> void:
	if not object or not callable:
		return
	var node = base.get_tree().get_root().get_node(object)
	if callable in node:
		if not parameters:
			node.call(callable)
		else:
			node.call(callable,parameters)

func get_color() -> Color:
	var output: Color = Global.color_TextBright
	if failed:
		output = Color.DARK_RED
	return output
