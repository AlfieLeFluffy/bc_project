class_name ApplicationContent extends Control

#region Variables
"""
--- Runtime Variables
"""
var computer: ComputerBase
var arguments: Dictionary
#endregion

#region Setup Methods
"""
--- Setup Methods
"""
func setup_application_content(_computer: ComputerBase) -> void:
	if _computer:
		computer = _computer
	_setup_content()

func _setup_content() -> void:
	pass

func setup_application_arguments(_arguments: Dictionary) -> void:
	if _arguments:
		arguments = _arguments
	_setup_arguments()

func _setup_arguments() -> void:
	pass
#endregion
