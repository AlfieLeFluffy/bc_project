class_name ApplicationTab extends Button

#region Variables
"""
--- Runtime Variable
"""
var computer: ComputerBase
var type: ApplicationResource.applicationTypes
#endregion

#region Setup Methods
"""
--- Setup Methods
"""
func setup_application_tab(_type: ApplicationResource.applicationTypes, _computer: ComputerBase) -> void:
	if _type:
		type = _type
	if _computer:
		computer = _computer
		self.name = computer.view.load_name(type)
		self.text = computer.view.load_name(type)
		self.icon = computer.view.load_icon(type)
	
	computer.view.application_set.connect(set_tab)
	computer.view.application_toggle.connect(toggle_tab)
	computer.view.application_exit.connect(exit_tab)
#endregion

#region Runtime Methods
"""
--- Runtime Methods
"""

func set_tab(_type: ApplicationResource.applicationTypes, state: bool) -> void:
	if type == _type:
		self.button_pressed = state

func toggle_tab(_type: ApplicationResource.applicationTypes) -> void:
	if type == _type:
		self.button_pressed = not self.button_pressed

func exit_tab(_type: ApplicationResource.applicationTypes) -> void:
	if type == _type:
		queue_free()
#endregion

#region Signal Methods
"""
--- Signal Methods
"""
func _on_pressed() -> void:
	computer.view.application_toggle.emit(type)
	self.button_pressed = not self.button_pressed
#endregion
