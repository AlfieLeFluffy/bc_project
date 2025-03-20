class_name CameraControls extends Node2D

@onready var trackedNode: Node2D

@onready var minZoom: Vector2 = Vector2(2.0,2.0)
@onready var maxZoom: Vector2 = Vector2(4.0,4.0)
@onready var zoomStep: Vector2 = Vector2(0.2,0.2)

var mousePossition: Vector2
var emptyPossition: Vector2
var tween: Tween




#region Setup Methods
func _ready() -> void:
	
	Signals.camera_tracked_node_set.connect(set_camera_tracked_node)
	Signals.camera_tracked_node_set_by_name.connect(set_camera_tracked_node_by_name)
	Signals.camera_tracked_node_set_player.connect(set_camera_tracked_node_player)
	Signals.camera_tracked_node_set_empty.connect(set_camera_tracked_node_empty)
	
	setup_initial_tracked_node()
	setup_zoom()

func setup_initial_tracked_node() -> void:
	if get_tree().get_node_count_in_group("Player") > 0:
		trackedNode = get_tree().get_first_node_in_group("Player")
	else:
		trackedNode = get_tree().current_scene
	

func setup_zoom() -> void:
	pass
#endregion



#region Runtime Methods
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		mousePossition = get_local_mouse_position()
	
	if event.is_action("zoom_in"):
		zoom(%MainCamera.zoom+zoomStep)
	elif event.is_action("zoom_out"):
		zoom(%MainCamera.zoom-zoomStep)

func _physics_process(delta: float) -> void:
	if trackedNode != null:
		global_position = trackedNode.position.lerp(to_global(mousePossition), 0.2)
	else:
		global_position = emptyPossition.lerp(to_global(mousePossition), 0.2)

func zoom(input: Vector2) -> void:
	tween = get_tree().create_tween()
	input = minZoom.max(input.min(maxZoom))
	tween.tween_property(%MainCamera, "zoom", input, 0.2).set_ease(Tween.EASE_IN_OUT)
#endregion



#region Runtime Methods
func set_camera_global_position(vector: Vector2) -> void:
	global_position = vector
	%MainCamera.global_position = vector
	%MainCamera.reset_smoothing()

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
#endregion



#region Persistence Methods
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
		%MainCamera.reset_smoothing()
	return true
#endregion
