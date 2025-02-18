extends Node

"""
--- Preload Scenes
"""
const preloadInGameMenu = preload("res://scenes/menus/ingame_menu.tscn")
const preloadPersistenceMenu = preload("res://scripts/persistence/persistence_menu.tscn")

"""
--- Signals
"""
signal openPersistenceMenu(mode)
signal saveGame(filename)
signal loadGame(filename)

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
	
	# Added group tag for persistence purposes
	add_to_group("Persistent")
	
	# File and folder integrity checks
	check_savefile_dir()
	
	# Connecting signals
	get_viewport().connect("gui_focus_changed", _on_focus_changed)
	DialogueManager.connect("dialogue_ended",release_focus)
	connect("openPersistenceMenu",open_persistence_menu)
	connect("saveGame", save_game)
	connect("loadGame", load_game)

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

func change_scene(sceneName:String) -> bool:
	sceneToLoad = Global.scenePaths[sceneName]
	if sceneToLoad:
		Global.currentScene = sceneName
		get_tree().change_scene_to_packed(load("res://scenes/menus/loading_screen.tscn"))
		return true
	return false

# Instantiates and shows the in-game menu
func open_ingame_menu() -> void:
	if get_tree().current_scene.name == "MainMenu":
		return
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

func open_persistence_menu(mode: int = 0) -> void:
	if mode > 1 or mode < 0:
		printerr("Wrong Persistence Mode Parameter")
		return
	var menu = preloadPersistenceMenu.instantiate()
	menu.mode = mode
	get_tree().current_scene.add_child(menu)
	menu.layer = 100

func check_savefile_dir() -> void:
	var dir = DirAccess.open(Global.savesDirectoryPath)
	if not dir:
		DirAccess.make_dir_absolute(Global.savesDirectoryPath)

func save_game(filename:String) -> void:
	# Master dictionary holding all saved data
	var saveDic: Dictionary = {}
	# Saves current scene
	saveDic["scene"] = Global.currentScene
	
	var save_nodes = get_tree().get_nodes_in_group("Persistent")
	for node in save_nodes:
		# Check the node has a save function.
		if !node.has_method("saving"):
			printerr("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		saveDic[node.get_path()] = node.saving()
	
	# Opens and prepares the savefile
	var save_file = FileAccess.open(Global.savesDirectoryPath+"/"+filename.rstrip(".sf")+".sf", FileAccess.WRITE)
	# JSON provides a static method to serialized JSON string.
	var json_string = JSON.stringify(saveDic)
	# Store the save dictionary as a new line in the save file.
	save_file.store_line(json_string)

func load_game(filename:String) -> void:
	# Checks if savefile exists
	if not FileAccess.file_exists(Global.savesDirectoryPath+"/"+filename):
		return # Error! We don't have a save to load.
	# Opens savefile
	var save_file = FileAccess.open(Global.savesDirectoryPath+"/"+filename, FileAccess.READ)
	var json_string = save_file.get_line()
	# Get the data from the JSON object.
	var dic = JSON.parse_string(json_string)
	
	# Loads current scene
	if not dic.has("scene"):
		printerr("Savefile doesn't have a scene to load.")
		return
	change_scene(dic["scene"])
	dic.erase("scene")
	
	await Signals.scene_loaded
	
	var save_nodes = get_tree().get_nodes_in_group("Persistent")
	for node in save_nodes:
		if dic.has(String(node.get_path())):
			node.loading(dic[String(node.get_path())])
			dic.erase(String(node.get_path()))
	
	for key in dic:
		if dic[key].has("node"):
			var node = load(dic[key]["node"])
			node = node.instantiate()
			var parent = get_node(dic[key]["parent"])
			parent.add_child(node)
			node.loading(dic[key])

"""
--- Persistence Methods
"""
func saving() -> Dictionary:
	var output: Dictionary = {}
	return output

func loading(input: Dictionary) -> bool:
	return true
