extends HBoxContainer

"""
--- Runtime Variables
"""
var menuNode: Node

"""
--- Node Signal Methods
"""
func _on_button_pressed() -> void:
	if $Name.text == "":
		return
	GameController.emit_signal("saveGame",$Name.text)
	menuNode.emit_signal("closeMenu")
