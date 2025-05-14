class_name ClueResource extends Resource

@export_category("Clue Information")
@export var combination:String
@export var label:String
@export_color_no_alpha var color: Color = Color.WHITE

@export_category("Callable Resource List")
@export var callables: Array[CallableResource]
