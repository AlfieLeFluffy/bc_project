extends HBoxContainer


"""
--- Runtime Variables
"""
var menuNode: Node
var filename: String
var date: String

"""
--- Setup Methods
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Name.text = filename.rstrip(".sf")
	$Date.text = date

"""
--- Node Signal Methods
"""
func _on_button_pressed() -> void:
	$ConfirmationDialog.popup()

func _on_confirmation_dialog_confirmed() -> void:
	if not filename:
		return
	GameController.emit_signal("loadGame",filename)
	menuNode.emit_signal("closeMenu")


func _on_delete_button_pressed() -> void:
	$DeleteConfirmationDialog.popup()

func _on_delete_confirmation_dialog_confirmed() -> void:
	DirAccess.remove_absolute(Global.savesDirectoryPath+"/"+filename)
	queue_free()
