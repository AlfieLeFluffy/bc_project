extends VBoxContainer

"""
--- Runtime Variables
"""
var active: bool = false

@export var icons: Dictionary

@onready var icon: TextureRect = $MContainer/Icon
@onready var label: Label = $ApplicationLabel

"""
--- Setup Methods
"""
func setup_application_shortcut(applicationType: ApplicationResource.applicationTypes) -> void:
	icon.texture = icons[ApplicationResource.applicationTypes.keys()[applicationType]]

"""
--- Signal Methods
"""
func _on_mouse_entered() -> void:
	active = true
	icon.material.set("shader_parameter/line_thickness",1)

func _on_mouse_exited() -> void:
	active = false
	icon.material.set("shader_parameter/line_thickness",0)
