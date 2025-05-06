class_name InteractiveHandler extends Node

#region Runtime Variables
## A parent node that should be holding all the parameters
@onready var parent: Node = get_parent()
## The player interactive radius instance reference
@onready var interactiveRadius:Node = get_tree().get_first_node_in_group("InteractiveRadius")
#endregion

"""
--- Setup methods
"""
#region Setup Methods
func _ready() -> void:
	
	Signals.s_MenuClear.connect(menu_clear)
#endregion

"""
--- Runtime Methods
"""

#region Signal Methods
## A method that deactivates interactivity when needed
func menu_clear() -> void:
	parent.deactivate_interactivity()

## A method that sets [param inRadius] to true when player interactivity radius enters 
func _on_area_entered(area: Area2D) -> void:
	if area.name == interactiveRadius.name:
		if parent.mouseHover:
			parent.activate_interactivity()
		parent.inRadius = true

## A method that sets [param inRadius] to false when player interactivity radius leaves 
func _on_area_exited(area: Area2D) -> void:
	if area.name == interactiveRadius.name:
		if parent.mouseHover:
			parent.deactivate_interactivity()
		parent.inRadius = false


## A method that sets [param mouseHover] to true when mouse enters the area
func _on_mouse_entered() -> void:
	parent.activate_hover()
	parent.mouseHover = true
	if parent.inRadius:
		parent.activate_interactivity()

## A method that sets [param mouseHover] to false when mouse leaves the area
func _on_mouse_exited() -> void:
	parent.deactivate_hover()
	parent.mouseHover = false
	if parent.inRadius:
		parent.deactivate_interactivity()
#endregion
