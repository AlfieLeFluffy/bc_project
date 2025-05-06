class_name CameraControls extends Node2D

## A Node2D variable keeping track of what node the camera controller tracks. [br]
## Can be set through global signals in 'Signals' autoload script: [br]
##	- [signal Signals.s_CameraTrackedNodeSet][br]
##	- [signal Signals.s_CameraTrackedNodeSetByName][br]
##	- [signal Signals.s_CameraTrackedNodeSetPlayer][br]
##	- [signal Signals.s_CameraTrackedNodeSetEmpty][br]
@onready var trackedNode: Node2D

## Vector2 that keeps track of last known mouse position in the local space.
var mousePosition: Vector2
## Vector2 that keeps last known global position before camera stops tracking any node.
var emptyPosition: Vector2



#region Setup Methods
func _ready() -> void:
	
	## Connecting global signals to local methods
	Signals.s_CameraTrackedNodeSet.connect(set_camera_tracked_node)
	Signals.s_CameraTrackedNodeSetByName.connect(set_camera_tracked_node_by_name)
	Signals.s_CameraTrackedNodeSetPlayer.connect(set_camera_tracked_node_player)
	Signals.s_CameraTrackedNodeSetEmpty.connect(set_camera_tracked_node_empty)
	
	## Setting up initial tracked node (Player)
	setup_initial_tracked_node()

## Method for setting up initial [param trackedNode] for the camera controler. [br]
## Initial node to track is the [Player] that should be added into the Player global group. [br]
## If the Player global group is empty then the camera starts tracking the scene itself as default.
func setup_initial_tracked_node() -> void:
	if get_tree().get_node_count_in_group("Player") > 0:
		trackedNode = get_tree().get_first_node_in_group("Player")
	else:
		trackedNode = get_tree().current_scene
#endregion



#region Runtime Methods
func _unhandled_input(event: InputEvent) -> void:
	## Sets local mouse position if input event is a mouse input event.
	if event is InputEventMouse:
		mousePosition = get_local_mouse_position()

func _physics_process(delta: float) -> void:
	## Moves controller and thus the camera to the tracked node position (or emprty space) independently from the mouse input.
	if trackedNode != null:
		global_position = trackedNode.position.lerp(to_global(mousePosition), 0.2)
	else:
		global_position = emptyPosition.lerp(to_global(mousePosition), 0.2)
#endregion



#region Runtime Methods
## Method for setting the global position of the camera and controler without smoothing. [br]
## Used for example in loading and timeshifting.
func set_camera_global_position(vector: Vector2) -> void:
	global_position = vector
	%MainCamera.global_position = vector
	%MainCamera.reset_smoothing()

## Method for setting the [param trackedNode] to a specific node.
func set_camera_tracked_node(node: Node) -> void:
	trackedNode = node

## Method for setting the [param trackedNode] to a node of name [param nodeName] in the group defined by name [param Global.CAMERA_FOCUS_GROUP_NAME].
func set_camera_tracked_node_by_name(nodeName: String) -> void:
	var nodes: Array = get_tree().get_nodes_in_group(Global.CAMERA_FOCUS_GROUP_NAME)
	var node: Node = GameController.find_node_by_name_in_array(nodes, nodeName)
	if node != null:
		set_camera_tracked_node(node)

## Method for setting the [param trackedNode] to the first node in the Player global group.
func set_camera_tracked_node_player() -> void:
	set_camera_tracked_node(Global.playerCharacterNode)

## Method for setting the [param trackedNode] to null and saving the last known global position of the tracked object in [param emptyPosition].
func set_camera_tracked_node_empty() -> void:
	if not trackedNode:
		return
	emptyPosition = trackedNode.global_position
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
