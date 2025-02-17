extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

func _input(event: InputEvent) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_menu") and not GameController.FocusSet:
		queue_free()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_menu") and GameController.FocusSet:
		GameController.release_focus()
	if visible:
		get_viewport().set_input_as_handled()

func _on_continue_button_pressed() -> void:
	queue_free()

func _on_settings_button_pressed() -> void:
	SettingsController.emit_signal("openSettingsMenu")

func _on_quit_button_pressed() -> void:
	GameController.change_scene("main_menu")
