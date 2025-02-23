class_name InteractiveHandler extends Node

"""
--- Runtime variables
"""
var parent

"""
--- Setup methods
"""
func _ready() -> void:
	parent = get_parent()
	
	Signals.connect("menu_clear", menu_clear)

"""
--- Global signal methods
"""

func menu_clear() -> void:
	parent.deactivate_interactivity()

"""
--- Area and mouse entry and leave functions
"""

func _on_area_entered(area: Area2D) -> void:
	if area.name == Global.interactive_radius_name:
		if parent.mouseHover:
			parent.activate_interactivity()
		parent.inRadius = true


func _on_area_exited(area: Area2D) -> void:
	if area.name == Global.interactive_radius_name:
		if parent.mouseHover:
			parent.deactivate_interactivity()
		parent.inRadius = false


func _on_mouse_entered() -> void:
	parent.activate_hover()
	parent.mouseHover = true
	if parent.inRadius:
		parent.activate_interactivity()


func _on_mouse_exited() -> void:
	parent.deactivate_hover()
	parent.mouseHover = false
	if parent.inRadius:
		parent.deactivate_interactivity()
