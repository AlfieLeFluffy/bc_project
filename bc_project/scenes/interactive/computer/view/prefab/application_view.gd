class_name ApplicationView extends Control

#region Variables, Constants, Signals and such
"""
--- Runtime Variable
"""
# Setup variables
var computer: ComputerBase
var type: ApplicationResource.applicationTypes
var contentInstance: ApplicationContent

# Active handling variables
var active: bool = false
var activeTobBar: bool = false
# State handling variables
var maximized: bool = false
var minimizedSize: Vector2 = self.get_minimum_size()
# Movement and size handling variables
var resizing: bool = false
var dragging: bool = false
var mouseOffset: Vector2
@onready var parent: Node = get_parent()

@export var setupAppOffset: int = 20

@export var applicationContents: Dictionary = {
	ApplicationResource.applicationTypes.FILE_EXPLORER: "res://scenes/interactive/computer/view/prefab/content_prefab/file_explorer_content.tscn",
	ApplicationResource.applicationTypes.COMMAND_PROMPT: "res://scenes/interactive/computer/view/prefab/content_prefab/command_prompt_content.tscn",
	ApplicationResource.applicationTypes.TEXT_VIEW: "res://scenes/interactive/computer/view/prefab/content_prefab/text_view_content.tscn",
}
#endregion

#region Setup Methods
"""
--- Setup Methods
"""

func setup_application_view(_type: ApplicationResource.applicationTypes, _computer: ComputerBase, _arguments: Dictionary) -> void:
	if _type:
		type = _type
	if _computer:
		computer = _computer
		self.name = "Application_View_"+computer.view.load_name(type)
		%ApplicationName.text = computer.view.load_name(type)
		%Icon.texture = computer.view.load_icon(type)
	
	computer.view.application_set.connect(set_applicatiion)
	computer.view.application_toggle.connect(toggle_applicatiion)
	computer.view.application_arguments.connect(setup_application_arguments)
	computer.view.application_exit.connect(exit_applicatiion)
	
	setup_default_possition()
	setup_application_content(_arguments)

func setup_default_possition() -> void:
	var appOffset: int = computer.appRes.activeApplications.size() * setupAppOffset
	position = Vector2((parent.size.x-size.x)/2+appOffset,(parent.size.y-size.y)/2+appOffset)

func setup_application_content(_arguments: Dictionary) -> void:
	if applicationContents.has(type):
		contentInstance = load(applicationContents[type]).instantiate()
		%Content.add_child(contentInstance)
		contentInstance.setup_application_content(computer)
		contentInstance.setup_application_arguments(_arguments)

func setup_application_arguments(_type: ApplicationResource.applicationTypes, _arguments:Dictionary) -> void:
	if type == _type and is_instance_valid(contentInstance):
		contentInstance.setup_application_arguments(_arguments)
#endregion

#region Runtime and Other Methods
"""
--- Runtime Methods
"""
func _gui_input(event: InputEvent) -> void:
	if activeTobBar and event.is_action_pressed("interact"):
		computer.view.application_set.emit(type, true)
		mouseOffset = position - get_global_mouse_position()
		dragging = true
	elif event.is_action_released("interact"):
		dragging = false

func _physics_process(delta: float) -> void:
	if dragging:
		position = get_global_mouse_position() + mouseOffset
		restrain_position()
	if resizing and not dragging:
		size = get_local_mouse_position() + mouseOffset
		restrain_size()
		restrain_position()

func restrain_position() -> void:
	position.x = max(position.x,0)
	position.y = max(position.y,0)
	position.x = min(position.x,parent.size.x - self.size.x)
	position.y = min(position.y,parent.size.y - self.size.y)

func restrain_size() -> void:
	size.x = min(size.x,parent.size.x)
	size.y = min(size.y,parent.size.y)

func update_maximize() -> void:
	maximized = not maximized
	if maximized:
		minimizedSize = size
		size = parent.size
		%ResizeButton.visible = false
		restrain_position()
	elif not maximized:
		size = minimizedSize
		%ResizeButton.visible = true
		setup_default_possition()
		restrain_position()

func set_applicatiion(_type: ApplicationResource.applicationTypes, _state: bool) -> void:
	if type == _type:
		visible = _state

func toggle_applicatiion(_type: ApplicationResource.applicationTypes) -> void:
	if type == _type:
		visible = not visible

func exit_applicatiion(_type: ApplicationResource.applicationTypes) -> void:
	if type == _type or _type == -1:
		queue_free()
#endregion

#region Signal Methods
"""
--- Singal Methods
"""
""" Activity Signals """
func _on_mouse_entered() -> void:
	active = true

func _on_mouse_exited() -> void:
	active = false

""" TopBar Activity Signals """
func _on_top_bar_mouse_entered() -> void:
	activeTobBar = true

func _on_top_bar_mouse_exited() -> void:
	activeTobBar = false


""" Minimize Button """
func _on_minimize_button_pressed() -> void:
	computer.view.application_toggle.emit(type)

""" Maximize Button """
func _on_maximize_button_pressed() -> void:
	update_maximize()

""" Close Button """
func _on_close_button_pressed() -> void:
	computer.view.application_exit.emit(type)


""" Resize Button """
func _on_resize_button_button_down() -> void:
	mouseOffset = size - get_local_mouse_position()
	resizing = true

func _on_resize_button_button_up() -> void:
	resizing = false
#endregion
