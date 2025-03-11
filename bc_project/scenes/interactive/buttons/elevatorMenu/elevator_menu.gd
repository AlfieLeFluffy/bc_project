class_name ElevatroButtons extends Interactable

#region Contants
const preloadElevatorMenuButton = preload("res://scenes/interactive/buttons/elevatorMenu/prefab/elevator_menu_button.tscn")
#endregion

#region Variables
var resource: ElevatorResource
var scaling: float
#endregion

#region Setup Methods
func local_ready() -> void:
	if get_elevator_resource():
		setup_menu_buttons()
	Signals.elevator_move_to_key.connect(hide_menu)

func get_elevator_resource() -> bool:
	var parent: Node = get_parent()
	while parent != null:
		if parent is Elevator:
			resource = parent.resource
			return true
		parent = parent.get_parent()
	return false

func setup_menu_buttons() -> void:
	for key in resource.stops:
		var button: ElevatorMenuButton = preloadElevatorMenuButton.instantiate()
		%StopButtons.add_child(button)
		button.name = "ElevatorMenuButton_key:%s" % key
		button.setup_button(resource.id,key)
		%StopButtons.move_child(button,0)

func setup_menu_size_position() -> void:
	scaling = %ButtonMenu.scale.x
	%ButtonMenu.size = %StopButtons.size
	%ButtonMenu.position = Vector2.ZERO - %StopButtons.size/(2*(1/scaling))
#endregion

#region Runtime Methods
func local_process(delta: float) -> void:
	if %ButtonMenu.visible:
		if not Rect2(Vector2(),$ButtonMenu.size).has_point($ButtonMenu.get_local_mouse_position()):
			$ButtonMenu.visible = false

func interact_function(event: InputEvent) -> void:
	if not resource.active:
		$ButtonMenu.visible = true
		setup_menu_size_position()

func hide_menu(id,key) -> void:
	$ButtonMenu.visible = false
#endregion
