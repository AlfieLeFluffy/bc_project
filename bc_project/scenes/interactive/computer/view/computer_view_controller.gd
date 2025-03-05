extends CanvasLayer

"""
--- Preload Constants
"""
const preloadApplicationShortcut = preload("res://scenes/interactive/computer/view/prefab/application_shortcut.tscn")

"""
--- Runtime Variables
"""
signal create_board_element()

var computerResource: ComputerObjectResource
var directoryFileResource: DirectoryFileResource
var applicationResource: ApplicationResource

@onready var computer: Control = $Computer
@onready var appGrid: GridContainer = computer.get_node("Applications")

"""
--- Setup Methods
"""
func _ready() -> void:
	pass

func setup_computer_view(_computerResource: ComputerObjectResource, _directoryFileResource: DirectoryFileResource, _applicationResource: ApplicationResource) -> void:
	computerResource = _computerResource
	directoryFileResource = _directoryFileResource
	applicationResource = _applicationResource
	
	setup_shortcuts()

func setup_shortcuts() -> void:
	#for applicationKey in applicationResource.applications:
	#	if applicationResource.applications[applicationKey]:
	#		applicationResource.applicationTypes.find_key(applicationKey)
	var applicationShortcutInstance: Node = preloadApplicationShortcut.instantiate()
	appGrid.add_child(applicationShortcutInstance)
	applicationShortcutInstance.setup_application_shortcut(applicationResource.applicationTypes.FILE_EXPLORER)
	


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
	

"""
--- Signal Methdos
"""
func _on_shutdown_button_pressed() -> void:
	Signals.emit_signal("shutdown_computer",computerResource.computerName)
	exit_view()
