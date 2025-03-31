class_name InteractableResource extends Resource

"""
--- Exported Resource Variables
"""
@export_category("Item Information")
@export var item_name: String
@export var description: String
@export var detective_board_toggle: bool = true
@export var show_labels: bool = true
var timeline: String

@export_category("Item Information")
@export var dialogueResource: DialogueResource
