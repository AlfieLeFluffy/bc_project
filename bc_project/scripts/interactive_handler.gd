class_name InteractiveHandler extends Node

"""
--- Runtime variables
"""
@onready var parent: Node = get_parent()
@onready var interactiveRadius:Node = get_tree().get_first_node_in_group("InteractiveRadius")
"""
--- Setup methods
"""
func _ready() -> void:
	
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
	if area.name == interactiveRadius.name:
		if parent.mouseHover:
			parent.activate_interactivity()
		parent.inRadius = true


func _on_area_exited(area: Area2D) -> void:
	if area.name == interactiveRadius.name:
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
