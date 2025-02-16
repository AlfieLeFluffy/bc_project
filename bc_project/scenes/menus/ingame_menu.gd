extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().connect("gui_focus_changed", _on_focus_changed)
	visible = false

func _input(event: InputEvent) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ingame_menu_toggle") and not Global.FocusSet:
		toggle_ingame_menu()
	elif event.is_action_pressed("ingame_menu_toggle") and Global.FocusSet:
		Global.release_focus()
	if visible:
		get_viewport().set_input_as_handled()

func _on_focus_changed(control:Control) -> void:
	Global.FocusSet = true

func toggle_ingame_menu() -> void:
	visible = not visible


func _on_continue_button_pressed() -> void:
	toggle_ingame_menu()


func _on_settings_button_pressed() -> void:
	SettingsController.emit_signal("openSettingsMenu")


func _on_quit_button_pressed() -> void:
	Global.NextScene = "res://scenes/menus/main_menu.tscn"
	get_tree().change_scene_to_packed(load("res://scenes/menus/loading_screen.tscn"))
