class_name InteractableResource extends Resource

"""
--- Exported Resource Variables
"""
@export_category("Item Information")
@export var item_name: String
@export var description: String
@export var detective_board_toggle: bool = true
@export var show_labels: bool = true
@export var show_outline: bool = true
@export var ignore_line_of_sight: bool = false
var timeline: String

@export_category("Callable Resource List")
@export var callables: Array[CallableResource]
