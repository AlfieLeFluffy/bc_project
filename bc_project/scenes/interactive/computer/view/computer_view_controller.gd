extends CanvasLayer

"""
--- Runtime Variables
"""
signal create_board_element()

var type: ComputerObjectResource.computerTypeEnum
var computerName: String


"""
--- Setup Methods
"""
func _ready() -> void:
	pass

func setup_computer_view(computerResource: ComputerObjectResource, directoryFileResource: DirectoryFileResource, applicationResource: ApplicationResource) -> void:
	type = computerResource.computerType
	computerName = computerResource.computerName
	

"""
--- Runtime Methdos
"""
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_menu"):
		exit_view()
		get_viewport().set_input_as_handled()
	"""elif event.is_action_pressed("add_to_board"):
		emit_signal("create_board_element", null)
		exit_view()"""

func exit_view() ->void:
	queue_free()

func _on_button_pressed() -> void:
	Signals.emit_signal("shutdown_computer",computerName)
	exit_view()
