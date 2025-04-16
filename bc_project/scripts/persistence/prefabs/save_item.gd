class_name SaveItem extends MarginContainer


"""
--- Runtime Variables
"""
#region Variables
var menuNode: Node
var filename: String
var date: String
var dateString: String
#endregion



"""
--- Setup Methods
"""
#region Setup Methods
func _ready() -> void:
	%Name.text = filename.rstrip(".sf")
	%Date.text = date
#endregion



"""
--- Node Signal Methods
"""
#region Node Signal Methods
func _on_button_pressed() -> void:
	%ConfirmationDialog.popup()

func _on_confirmation_dialog_confirmed() -> void:
	if not filename:
		return
	PersistenceController.s_SaveGame.emit(filename)
	menuNode.emit_signal("closeMenu")

func _on_delete_button_pressed() -> void:
	%DeleteConfirmationDialog.popup()

func _on_delete_confirmation_dialog_confirmed() -> void:
	PersistenceController.s_SavefileDelete.emit(filename)
	queue_free()
#endregion
