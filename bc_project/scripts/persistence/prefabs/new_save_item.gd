extends HBoxContainer

"""
--- Runtime Variables
"""
var menuNode: Node
var dateString: String = "zzzzzzzzzzzzz"

"""
--- Node Signal Methods
"""
func _on_button_pressed() -> void:
	if $Name.text == "":
		return
	PersistenceController.s_SaveGame.emit(GameController.get_profile_id(), $Name.text)
	menuNode.emit_signal("closeMenu")
