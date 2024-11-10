extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().connect("gui_focus_changed", _on_focus_changed)
	visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ingame_menu_toggle") and not Global.FocusSet:
		toggle_ingame_menu()
	elif event.is_action_pressed("ingame_menu_toggle") and Global.FocusSet:
		Global.release_focus()

func _on_focus_changed(control:Control) -> void:
	Global.FocusSet = true

func toggle_ingame_menu() -> void:
	if visible:
		Global.close_menu()
		visible = 0
	else:
		Global.open_menu()
		visible = 1


func _on_continue_button_pressed() -> void:
	toggle_ingame_menu()


func _on_settings_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	Global.NextScene = "res://scenes/menus/main_menu.tscn"
	get_tree().change_scene_to_packed(load("res://scenes/menus/loading_screen.tscn"))
