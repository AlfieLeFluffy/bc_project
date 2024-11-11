extends Node

var parent

func _ready() -> void:
	parent = get_parent()

"""
--- Area and mouse entry and leave functions
"""

func _on_interactable_base_area_entered(area: Area2D) -> void:
	if area.name == Global.interactive_radius_name:
		if parent.mouseHover:
			parent.activate_interactivity()
		parent.inRadius = true


func _on_interactable_base_area_exited(area: Area2D) -> void:
	if area.name == Global.interactive_radius_name:
		if parent.mouseHover:
			parent.deactivate_interactivity()
		parent.inRadius = false


func _on_interactable_base_mouse_entered() -> void:
	parent.activate_hover()
	parent.mouseHover = true
	if parent.inRadius:
		parent.activate_interactivity()


func _on_interactable_base_mouse_exited() -> void:
	parent.deactivate_hover()
	parent.mouseHover = false
	if parent.inRadius:
		parent.deactivate_interactivity()
