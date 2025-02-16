extends Node

"""
--- Setup functions
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VB/Version.text = "Version " + ProjectSettings.get_setting("application/config/version")

"""
--- Node Signal Methods
"""

func _on_test_scene_button_pressed() -> void:
	Global.NextScene = "res://scenes/levels/test_level.tscn"
	get_tree().change_scene_to_packed(load("res://scenes/menus/loading_screen.tscn"))

func _on_quit_button_pressed() -> void:
	get_tree().quit(0)

func _on_settings_button_pressed() -> void:
	SettingsController.emit_signal("openSettingsMenu")
