extends Node2D

"""
--- Runtime Variables
"""
@onready var trackedNode: Node
var mouse_position: Vector2

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
	
	Signals.connect("cemera_tracked_node_set",set_camera_tracked_node)
	Signals.connect("cemera_tracked_node_set_by_name", set_camera_tracked_node_by_name)
	Signals.connect("cemera_tracked_node_set_player", set_camera_tracked_node_player)


"""
--- Runtime Methods
"""

func _unhandled_input(event: InputEvent) -> void:
	mouse_position = get_global_mouse_position() 

func _physics_process(delta: float) -> void:
	global_position = trackedNode.position.lerp(mouse_position, 0.2); 

"""
--- Set Methods
"""
func set_camera_tracked_node(node: Node) -> void:
	if node is Node:
		trackedNode = node

func set_camera_tracked_node_by_name(nodeName: String) -> void:
	var nodes: Array = get_tree().get_nodes_in_group(Global.cameraFocusName)
	var node: Node = GameController.find_node_by_name_in_array(nodes, nodeName)
	if node != null:
		set_camera_tracked_node(node)

func set_camera_tracked_node_player() -> void:
	set_camera_tracked_node(Global.playerCharacterNode)

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
		"posCamX": %MainCamera.position.x,
		"posCamY": %MainCamera.position.y,
	}
	return output

func loading(input: Dictionary) -> bool:
	if input.has_all(["posConX","posConY","posCamX","posCamY"]):
		position = Vector2(input["posConX"],input["posConY"])
		%MainCamera.position = Vector2(input["posCamX"],input["posCamY"])
	return true
