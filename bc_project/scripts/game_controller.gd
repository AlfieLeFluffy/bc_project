extends Node

"""
--- Preload Scenes
"""
const preloadInGameMenu = preload("res://scenes/menus/ingame_menu.tscn")

"""
--- Runtime Variables
"""
# Flag for if focus is set
var FocusSet:bool = false

var sceneToLoad:String = ""

"""
--- Setup Methods
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().connect("gui_focus_changed", _on_focus_changed)
	DialogueManager.connect("dialogue_ended",release_focus)

"""
--- Runtime Methods
"""
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_menu"):
		open_ingame_menu()
		get_viewport().set_input_as_handled()

"""
--- Gloabal Minsc Methods
"""

func change_scene(sceneName:String) -> void:
	sceneToLoad = Global.scene_paths[sceneName]
	get_tree().change_scene_to_packed(load("res://scenes/menus/loading_screen.tscn"))

# Instantiates and shows the in-game menu
func open_ingame_menu() -> void:
	var menu = preloadInGameMenu.instantiate()
	get_tree().current_scene.add_child(menu)
	menu.layer = 90
	menu.visible = true

# Returns number of keys bound to input map
func get_input_key_count(inputName: String) -> int:
	if InputMap.has_action(inputName):
		return InputMap.action_get_events(inputName).size()
	return -1

# Returns key bound to input map by index
# Default index is 0
func get_input_key(inputName: String, index: int = 0) -> String:
	if InputMap.has_action(inputName):
		var output = InputMap.action_get_events(inputName)[index].as_text().split("(")[0]
		return output.left(output.length()-1)
	return ""

# Returns all keys bound to input map in an array
func get_input_key_list(inputName: String) -> Array:
	var output: Array[String] = []
	for x in range(get_input_key_count(inputName)):
		output.append(get_input_key(inputName,x))
	return output

# Called if focus has been set
func _on_focus_changed(control:Control) -> void:
	FocusSet = true

# Can be called to reset focus
func release_focus(resource = null) -> void:
	if FocusSet:
		get_viewport().gui_release_focus()
		FocusSet = false
