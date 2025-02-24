extends Node

"""
--- Setup functions
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VB/Version.text = tr("VERSION_LABEL") + ": " + ProjectSettings.get_setting("application/config/version")

"""
--- Node Signal Methods
"""

func _on_test_scene_button_pressed() -> void:
	GameController.change_scene("test_level")

func _on_quit_button_pressed() -> void:
	get_tree().quit(0)

func _on_settings_button_pressed() -> void:
	SettingsController.emit_signal("openSettingsMenu")

func _on_load_button_pressed() -> void:
	GameController.emit_signal("openPersistenceMenu",1)
