class_name InteractableResource extends Resource

enum type_enum {interactable, noninteractable}

@export_group("item information")
@export var item_name: String
@export var timeline: String
@export var type: type_enum
@export var description: String


@export_group("dialog")
@export var dialogIndex: int = 0 
@export var dialogs: Array[DialogueResource]
@export var titleIndex: int = 0 
@export var titles: PackedStringArray
