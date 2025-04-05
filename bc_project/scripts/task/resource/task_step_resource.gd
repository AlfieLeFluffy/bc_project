class_name TaskStepResource extends Resource

@export var name: String

@export var next: Array[TaskStepResource]

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
