extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HBoxContainer/VBoxContainer/Version.text = "Version " + ProjectSettings.get_setting("application/config/version")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_test_scene_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/test_level.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit(0)
