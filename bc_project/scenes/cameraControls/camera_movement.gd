extends Node2D

"""
--- Runtime Variables
"""
@onready var trackedNode: Node2D
var mousePossition: Vector2
var emptyPossition: Vector2

"""
--- Setup Methods
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_tree().get_node_count_in_group("Player") > 0:
		trackedNode = get_tree().get_first_node_in_group("Player")
	else:
		trackedNode = get_tree().current_scene
	
	Signals.camera_tracked_node_set.connect(set_camera_tracked_node)
	Signals.camera_tracked_node_set_by_name.connect(set_camera_tracked_node_by_name)
	Signals.camera_tracked_node_set_player.connect(set_camera_tracked_node_player)
	Signals.camera_tracked_node_set_empty.connect(set_camera_tracked_node_empty)


"""
--- Runtime Methods
"""

func _unhandled_input(event: InputEvent) -> void:
	mousePossition = get_local_mouse_position()

func _physics_process(delta: float) -> void:
	if trackedNode != null:
		global_position = trackedNode.position.lerp(to_global(mousePossition), 0.2)
	else:
		global_position = emptyPossition.lerp(to_global(mousePossition), 0.2)

"""
--- Set Methods
"""
func set_camera_tracked_node(node: Node) -> void:
	trackedNode = node

func set_camera_tracked_node_by_name(nodeName: String) -> void:
	var nodes: Array = get_tree().get_nodes_in_group(Global.cameraFocusName)
	var node: Node = GameController.find_node_by_name_in_array(nodes, nodeName)
	if node != null:
		set_camera_tracked_node(node)

func set_camera_tracked_node_player() -> void:
	set_camera_tracked_node(Global.playerCharacterNode)

func set_camera_tracked_node_empty() -> void:
	if not trackedNode:
		return
	emptyPossition = trackedNode.global_position
	set_camera_tracked_node(null)

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
