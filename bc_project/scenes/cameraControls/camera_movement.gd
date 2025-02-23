extends Node2D

"""
--- Runtime Variables
"""
@onready var trackedNode: Node
@onready var mainCemara: Camera2D = get_node("MainCamera")

"""
--- Setup Methods
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var playerGroup = get_tree().get_nodes_in_group("Player")
	if not playerGroup.is_empty():
		trackedNode = playerGroup[0]
	else:
		trackedNode = get_tree().current_scene
	
	Signals.connect("set_tracked_node",set_tracked_node)


"""
--- Runtime Methods
"""

#func _unhandled_input(event: InputEvent) -> void:
#	if event:
#		global_position = trackedNode.position.lerp(get_global_mouse_position(), 0.2); 

func _physics_process(delta: float) -> void:
	global_position = trackedNode.position.lerp(get_global_mouse_position(), 0.2); 

"""
--- Set Methods
"""
func set_tracked_node(node: Node) -> void:
	if node is Node:
		trackedNode = node


"""
--- Persistence Methods
"""
func saving() -> Dictionary:
	var output: Dictionary = {
		"persistent": true,
		"nodepath": get_path(),
		"parent": get_parent().get_path(),
		"posConX": position.x,
		"posConY": position.y,
		"posCamX": mainCemara.position.x,
		"posCamY": mainCemara.position.y,
	}
	return output

func loading(input: Dictionary) -> bool:
	if input.has_all(["posConX","posConY","posCamX","posCamY"]):
		position = Vector2(input["posConX"],input["posConY"])
		mainCemara.position = Vector2(input["posCamX"],input["posCamY"])
	return true
