class_name NPCResource extends Resource

@export_category("Npc Information")
@export var npcName: String
@export var description: String
var timeline: String

@export_category("Callable Resource List")
@export var callables: Array[CallableResource]
