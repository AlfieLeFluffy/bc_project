extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	match OS.get_name():
		"Windows","Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
			pass
		_:
			%SaveButton.tooltip_text = tr("OS_SAVEFILE_NOT_SUPPORTED_TOOLTIP")
			%SaveButton.disabled = true
			%LoadButton.tooltip_text = tr("OS_SAVEFILE_NOT_SUPPORTED_TOOLTIP")
			%LoadButton.disabled = true
	
	visible = false
	
	%ContinueButton.grab_focus()

func _input(event: InputEvent) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_menu") and not GameController.check_release_focus():
		queue_free()
		get_viewport().set_input_as_handled()
	if visible:
		get_viewport().set_input_as_handled()

func _on_continue_button_pressed() -> void:
	queue_free()

func _on_settings_button_pressed() -> void:
	SettingsController.s_SettingsMenuOpen.emit()

func _on_quit_button_pressed() -> void:
	GameController.change_scene("main_menu")

func _on_save_button_pressed() -> void:
	PersistenceController.s_PersistenceMenuOpen.emit(PersistenceMenu.e_Mode.SAVE)

func _on_load_button_pressed() -> void:
	PersistenceController.s_PersistenceMenuOpen.emit(PersistenceMenu.e_Mode.LOAD)
