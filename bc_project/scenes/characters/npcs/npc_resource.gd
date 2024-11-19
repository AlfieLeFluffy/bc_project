class_name npcResource extends Resource

@export_group("Npc Information")
@export var npcName: String

@export_group("Dialog")
@export var dialogIndex: int = 0 
@export var dialogs: Array[DialogueResource]
@export var titleIndex: int = 0 
@export var titles: PackedStringArray
