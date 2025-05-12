class_name ElevatroButtons extends Interactable

#region Contants
const preloadElevatorMenuButton = preload("res://scenes/interactive/buttons/elevatorMenu/prefab/elevator_menu_button.tscn")
#endregion

#region Variables
@export var offset: Vector2 = Vector2i(6,6)
var elevator: Elevator
var scaling: float
var buttons: Dictionary
#endregion

#region Setup Methods
func _local_ready() -> void:
	await get_tree().create_timer(0.1).timeout
	
	if get_elevator():
		setup_menu_buttons()
		if elevator.resource.movingToStop != null:
			setup_buttons_status(elevator.resource.id, elevator.resource.movingToStop)
		else:
			setup_buttons_status(elevator.resource.id, elevator.resource.currentStop)
	
	Signals.s_ElevatorMoveToKey.connect(hide_menu)
	Signals.s_ElevatorMoveToKey.connect(setup_buttons_status)

func get_elevator() -> bool:
	var parent: Node = get_parent()
	while parent != null:
		if parent is Elevator:
			elevator = parent
			return true
		parent = parent.get_parent()
	return false

func setup_menu_buttons() -> void:
	for key in elevator.stops:
		var button: ElevatorMenuButton = preloadElevatorMenuButton.instantiate()
		%StopButtons.add_child(button)
		button.name = "ElevatorMenuButton_key:%s" % key
		button.setup_button(elevator.resource.id,key)
		buttons[key] = button
		%StopButtons.move_child(button,0)

func setup_buttons_status(_id: String, _key: String, _force: bool = false) -> void:
	if elevator.resource.id != _id:
		return
	for key in buttons.keys():
		if key == _key:
			buttons[key].disabled = true
		else:
			buttons[key].disabled = false

func setup_menu_size_position() -> void:
	scaling = %ButtonMenu.scale.x
	%ButtonMenu.size = %StopButtons.size + offset
	%ButtonMenu.position = Vector2.ZERO - %StopButtons.size/(2*(1/scaling)) - offset / 2
#endregion

#region Runtime Methods
func _local_process(delta: float) -> void:
	if %ButtonMenu.visible:
		if not Rect2(Vector2(),$ButtonMenu.size).has_point($ButtonMenu.get_local_mouse_position()):
			$ButtonMenu.visible = false

func _interact_function(event: InputEvent) -> void:
	if not elevator.resource.active:
		$ButtonMenu.visible = true
		setup_menu_size_position()

func hide_menu(id:String,stop,force:bool = false) -> void:
	$ButtonMenu.visible = false
#endregion
