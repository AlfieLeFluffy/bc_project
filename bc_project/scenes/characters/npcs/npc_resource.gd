class_name NPCResource extends Resource

@export_category("Npc Information")
@export var npcName: String
@export_multiline var description: String
var timeline: String

@export_category("Callable Resource List")
@export var callables: Array[CallableResource]
