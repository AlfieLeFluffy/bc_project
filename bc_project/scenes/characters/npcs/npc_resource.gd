class_name NPCResource extends Resource

@export_category("Npc Information")
@export var npcName: String
@export var spritesheet: Texture
@export var frameVector: Vector2 = Vector2(1,1)

@export_category("Callable Resource List")
@export var callables: Array[CallableResource]
