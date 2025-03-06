class_name ApplicationShortcut extends VBoxContainer

#region Variables
"""
--- Runtime Variables
"""
var active: bool = false
var computer: ComputerBase
var type: ApplicationResource.applicationTypes
#endregion

#region Setup Methods
"""
--- Setup Methods
"""
func setup_application_shortcut(_type: ApplicationResource.applicationTypes,  _computer: ComputerBase) -> void:
	if _type:
		type = _type
	if _computer:
		computer = _computer
		name = computer.view.load_name(_type)
		%ApplicationLabel.text = computer.view.load_name(_type)
		%Icon.texture = computer.view.load_icon(_type)
#endregion

#region Runtime Methods
"""
--- Runtime Methods
"""
func _gui_input(event: InputEvent) -> void:
	if active and event.is_action_pressed("interact"):
		computer.view.application_open.emit(type, {})
#endregion

#region Signal Methods
"""
--- Signal Methods
"""
func _on_mouse_entered() -> void:
	active = true
	%Icon.material.set("shader_parameter/line_thickness",1)

func _on_mouse_exited() -> void:
	active = false
	%Icon.material.set("shader_parameter/line_thickness",0)
#endregion
