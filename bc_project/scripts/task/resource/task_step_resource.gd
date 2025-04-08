class_name TaskStepResource extends Resource

@export var name: String

@export var next: Array[TaskStepResource]
@export var failed: bool = false

@export_category("Step Callable Commands")
@export var callables: Array[CallableResource]

func run_commands(base: Node) -> void:
	for callable in callables:
		if callable is CallableResource:
			callable.run(base)

func get_color() -> Color:
	var output: Color = Global.color_TextBright
	if failed:
		output = Color.DARK_RED
	return output
