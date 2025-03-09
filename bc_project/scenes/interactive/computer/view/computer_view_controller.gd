class_name ComputerView extends CanvasLayer

#region Variables, Constans, Signals and such
"""
--- Preload Constants
"""
const preloadApplicationShortcut = preload("res://scenes/interactive/computer/view/prefab/application_shortcut.tscn")
const preloadApplicationTab = preload("res://scenes/interactive/computer/view/prefab/application_tab.tscn")
const preloadApplicationView = preload("res://scenes/interactive/computer/view/prefab/application_view.tscn")

"""
--- Signals
"""
signal application_open(type: ApplicationResource.applicationTypes, arguments: Dictionary)
signal application_arguments(type: ApplicationResource.applicationTypes, arguments: Dictionary)
signal application_set(type: ApplicationResource.applicationTypes, state: bool)
signal application_toggle(type: ApplicationResource.applicationTypes)
signal application_exit(type: ApplicationResource.applicationTypes)

"""
--- Runtime Variables
"""
var computer: ComputerBase

@export var appInfo: Dictionary = {
	ApplicationResource.applicationTypes.FILE_EXPLORER : ["FILE_EXPLORER_APPLICATION_NAME","res://textures/computer/application_icons/file_explorer_icon.png"],
	ApplicationResource.applicationTypes.COMMAND_PROMPT : ["COMMAND_PROMPT_APPLICATION_NAME", "res://textures/computer/application_icons/command_prompt_icon.png",],
	ApplicationResource.applicationTypes.TEXT_VIEW : ["TEXT_VIEW_APPLICATION_NAME","res://textures/computer/application_icons/text_viewer_icon.png",],
}

#endregion

#region Setup Methods
"""
--- Setup Methods
"""
func _ready() -> void:
	application_open.connect(open_application)
	application_toggle.connect(toggle_application)
	application_set.connect(set_application)
	application_exit.connect(exit_application)

func setup_computer_view(_computer:ComputerBase) -> void:
	computer = _computer
	
	if computer.compRes.computerName:
		name = "Computer_View_"+ computer.compRes.computerName
	
	setup_shortcuts()

func setup_shortcuts() -> void:
	for key in computer.appRes.applications.keys():
		if not computer.appRes.applications[key]:
			continue
		else:
			create_application_shortcut(key)

func create_application_shortcut(key: ApplicationResource.applicationTypes) -> void:
	var applicationShortcutInstance: ApplicationShortcut = preloadApplicationShortcut.instantiate()
	%ApplicationsShortcuts.add_child(applicationShortcutInstance)
	applicationShortcutInstance.setup_application_shortcut(key, computer)
#endregion

#region Runtime and Other Methods
"""
--- Runtime Methdos
"""
func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_menu"):
		exit_view()
		get_viewport().set_input_as_handled()
	if visible:
		get_viewport().set_input_as_handled()
	"""elif event.is_action_pressed("add_to_board"):
		emit_signal("create_board_element", null)
		exit_view()"""

""" Loading application names and icons """
func load_name(key: ApplicationResource.applicationTypes) -> String:
	var appName: String = "missing_name"
	if appInfo.has(key):
		if appInfo[key].size() >= 1:
			appName = appInfo[key][0]
	return appName

func load_icon(key: ApplicationResource.applicationTypes) -> CompressedTexture2D:
	var compTexture: CompressedTexture2D
	if appInfo.has(key):
		if appInfo[key].size() >= 2:
			compTexture = load(appInfo[key][1])
	return compTexture

""" Application Signal Methods """
func open_application(_type: ApplicationResource.applicationTypes, arguments: Dictionary) -> void:
	if computer.appRes.activeApplications.has(_type):
		order_application(_type)
		application_arguments.emit(_type, arguments)
		application_set.emit(_type, true)
		return
	create_application_instance(_type, arguments)
	application_set.emit(_type, true)
	order_application(_type)

func toggle_application(_type: ApplicationResource.applicationTypes) -> void:
	if not computer.appRes.activeApplications.has(_type):
		printerr("Error: cannot TOGGLE application that isn't part of active applications dictionary, type:" + str(_type))
		return
	order_application(_type)
	#application_set.emit(_type, not computer.appRes.activeApplications[_type]["view"].visible)

func set_application(_type: ApplicationResource.applicationTypes, state: bool) -> void:
	order_application(_type)

func exit_application(_type: ApplicationResource.applicationTypes) -> void:
	if not computer.appRes.activeApplications.has(_type):
		printerr("Error: cannot EXIT application that isn't part of active applications dictionary, type:" + str(_type))
		return
	computer.appRes.activeApplications.erase(_type)

func order_application(_type: ApplicationResource.applicationTypes) -> void:
	if not computer.appRes.activeApplications.has(_type):
		printerr("Error: cannot ORDER application that isn't part of active applications dictionary, type:" + str(_type))
		return
	if not computer.appRes.activeApplications[_type].has("view"):
		printerr("Error: cannot ORDER application that doesn't have a view in the active applications dictionary, type:" + str(_type))
		return
	var appView: ApplicationView = computer.appRes.activeApplications[_type]["view"]
	appView.move_to_front()

""" Open/Create Application Methods """
func create_application_instance(_type: ApplicationResource.applicationTypes, arguments: Dictionary) -> void:
	var appView: ApplicationView = create_application_view(_type, arguments)
	var appTab: ApplicationTab = create_application_tab(_type)
	computer.appRes.activeApplications[_type] = {
		"view": appView,
		"tab": appTab,
		}

func create_application_view(_type: ApplicationResource.applicationTypes, _arguments: Dictionary) -> ApplicationView:
	var applicationViewInstance: ApplicationView = preloadApplicationView.instantiate()
	%ScreenSpace.add_child(applicationViewInstance)
	applicationViewInstance.setup_application_view(_type, computer, _arguments)
	return applicationViewInstance

func create_application_tab(_type: ApplicationResource.applicationTypes) -> ApplicationTab:
	var applicationTabInstance: ApplicationTab = preloadApplicationTab.instantiate()
	%ApplicationsBar.add_child(applicationTabInstance)
	applicationTabInstance.setup_application_tab(_type, computer)
	return applicationTabInstance

""" View Control Methods """
func exit_view() ->void:
	Signals.emit_signal("hide_computer_view",computer.compRes.computerName)

func shutdown_computer() -> void:
	computer.appRes.activeApplications.clear()
	queue_free()
#endregion

#region Signal Methods
"""
--- Signal Methdos
"""
func _on_background_button_pressed() -> void:
	exit_view()

func _on_start_index_pressed(index: int) -> void:
	match index:
		0:
			Signals.emit_signal("shutdown_computer",computer.compRes.computerName)
			shutdown_computer()
		_:
			printerr("Start menu index out of bounds")
#endregion
