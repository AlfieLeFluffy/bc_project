extends Node

"""
--- Preload Scenes
"""
const preloadInGameMenu = preload("res://scenes/menus/ingame_menu.tscn")
const preloadPersistenceMenu = preload("res://scripts/persistence/persistence_menu.tscn")
const preloadMainOverlay = preload("res://scenes/UI/overlay/main_overlay.tscn")
const preloadInputHelp = preload("res://scenes/UI/input_help/input_help.tscn")

"""
--- Preload ScreenEffects
"""
const preloadTimelineShiftEffect = preload("res://scenes/screenEffects/timeline_shift_effect.tscn")

enum screenEffectEnum {TIMELINE_SHIFT}
const screenEffects: Dictionary = {
	screenEffectEnum.TIMELINE_SHIFT : preloadTimelineShiftEffect,
}

"""
--- Signals
"""
signal openPersistenceMenu(mode)
signal saveGame(filename)
signal loadGame(filename)

signal setMainOverlayVisibility(state)

signal playScreenEffect(effect)

"""
--- Runtime Variables
"""
# Flag for if focus is set
var FocusSet:bool = false

var sceneToLoad:String = ""

# Node for further control over overlays
var mainOverlay: Node
var inputHelp: Node

"""
--- Setup Methods
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Added group tag for persistence purposes
	add_to_group("Persistent")
	
	# File and folder integrity checks
	check_directory(Global.savesDirectoryPath)
	
	# Connecting signals
	get_viewport().connect("gui_focus_changed", _on_focus_changed)
	DialogueManager.connect("dialogue_ended",release_focus)
	DialogueManager.connect("got_dialogue",dialogue_voice_check)
	connect("openPersistenceMenu",open_persistence_menu)
	connect("saveGame", save_game)
	connect("loadGame", load_game)
	Signals.connect("scene_loaded",setup_main_overlay_menu)
	Signals.connect("scene_loaded",setup_input_help_menu)
	connect("setMainOverlayVisibility",set_main_overlay_visibility)
	connect("playScreenEffect",play_screen_effect)

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
	
# Checks if the currecnt scene is a nongameplay one
# Return true if yes and false if not
func check_nongameplay_scene() -> bool:
	var current_scene_name = get_tree().current_scene.name
	if current_scene_name in Global.nongameplayScenes:
		return true
	return false

# Instantiates and shows the in-game menu
func open_ingame_menu() -> void:
	# Checks if the scene name or filename is in the nongameplay scenes
	# If the scene is a non gameplay one this menu cannot open
	if check_nongameplay_scene():
		return
	var menu = preloadInGameMenu.instantiate()
	get_tree().current_scene.add_child(menu)
	menu.layer = 90
	menu.visible = true
	Signals.emit_signal("menu_clear")

# Returns number of keys bound to input map
func get_input_key_count(inputName: String) -> int:
	if InputMap.has_action(inputName):
		return InputMap.action_get_events(inputName).size()
	return -1

# Returns key bound to input map by index
# Default index is 0
func get_input_key(inputName: String, index: int = 0) -> String:
	if InputMap.has_action(inputName):
		var output = InputMap.action_get_events(inputName)[index].as_text()
		output = output.split("(")[0]
		output = output.split("-")[0]
		output = output.strip_edges()
		if output.contains(" "):
			output = create_inintials_from_string(output)
		return output
	printerr("No input key found during method get_input_key")
	return "null"

func create_inintials_from_string(input: String) -> String:
	if not input:
		printerr("No input given to the create_inintials_from_string method")
		return ""
	var output: String = ""
	for word in input.split(" "):
		output = output + word[0]
	return output

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

"""
--- Screen Effect Methods
"""
func play_screen_effect(effect: screenEffectEnum) -> void:
	var screenEffect = screenEffects[effect].instantiate()
	get_tree().current_scene.add_child(screenEffect)
	screenEffect.visible = true

"""
--- Overlay Methods
"""
# Instantiates and shows the in-game menu
func setup_main_overlay_menu() -> void:
	# Checks if the scene name is in the nongameplay scenes
	# If the scene is a non gameplay one this menu cannot open
	if check_nongameplay_scene():
		return
	mainOverlay = preloadMainOverlay.instantiate()
	get_tree().current_scene.add_child(mainOverlay)
	mainOverlay.layer = 50
	mainOverlay.visible = true

# Instantiates and shows the in-game menu
func setup_input_help_menu() -> void:
	# Checks if the scene name is in the nongameplay scenes
	# If the scene is a non gameplay one this menu cannot open
	if check_nongameplay_scene():
		return
	inputHelp = preloadInputHelp.instantiate()
	get_tree().current_scene.add_child(inputHelp)
	inputHelp.layer = 60
	inputHelp.visible = true

func set_main_overlay_visibility(state: bool) -> void:
	mainOverlay.visibility = state

"""
--- Dialogue Methods
"""
func dialogue_voice_check(line: DialogueLine) -> void:
	if line.translation_key:
		AudioManager.play_dialogue(line.translation_key)

"""
--- Directory Methods
"""
# Checks if a directory exists and creates one if not
func check_directory(directory:String) -> void:
	var dir = DirAccess.open(directory)
	if not dir:
		DirAccess.make_dir_absolute(directory)

# Deletes a directory and anything within said directory
func delete_directory_recurse(directoryPath:String) -> void:
	# Checks if directory exists, if not then exists
	if not DirAccess.dir_exists_absolute(directoryPath):
		return
	
	var dir = DirAccess.open(directoryPath)
	for file in dir.get_files():
		dir.remove(file)
	for directory in dir.get_directories():
		delete_directory_recurse(directoryPath.path_join(directory))
	DirAccess.remove_absolute(directoryPath)

"""
--- Save and Load Methods
"""

# Opens persistence menu either in save or load mode
func open_persistence_menu(mode: int = 0) -> void:
	if mode > 1 or mode < 0:
		printerr("Wrong Persistence Mode Parameter")
		return
	var menu = preloadPersistenceMenu.instantiate()
	menu.mode = mode
	get_tree().current_scene.add_child(menu)
	menu.layer = 100
	Signals.emit_signal("menu_clear")

""" Methods for saving and loading images in safe nodes """
# Saves an image in a dictionary into the img directory inside a savefile and sets flag to load it once loading
func save_img(key:String ,safeDirPath:String, dictionary:Dictionary) -> void:
	dictionary[key].get_image().save_png(safeDirPath.path_join("img").path_join(key+"_"+dictionary["name"])+".png")
	dictionary[key] = true

# Loads an image from the img directory if given flag is present in dictionary
func load_img(key, safeDirPath:String, dictionary: Dictionary) -> void:
	if not dictionary[key]:
		return
	if FileAccess.file_exists(safeDirPath.path_join("img").path_join(key+"_"+dictionary["name"])+".png"):
		var image = Image.load_from_file(safeDirPath.path_join("img").path_join(key+"_"+dictionary["name"])+".png")
		var texture = ImageTexture.create_from_image(image)
		dictionary[key] = texture

""" Methods for saving and loading one node dictonary as a JSON line """
# Takes a node dictionary, checks and saves any images, stringfies the node dictionary and writes into the savefile as a line
func save_line(safeFile, saveDirPath:String, dictionary:Dictionary) -> void:
	if dictionary.has("img"):
		save_img("img",saveDirPath,dictionary)
	var json = JSON.stringify(dictionary)
	safeFile.store_line(json)

# Reads one line of the savefile, parses the string into a dictionary, checks and laods any images and return node dictionary
func load_line(safeFile, safeDirPath:String) -> Dictionary:
	var json = safeFile.get_line()
	var parse =  JSON.parse_string(json)
	if parse.has("img"):
		load_img("img",safeDirPath, parse)
	return parse

""" Methods for saving and loading the game """
func save_game(filename:String) -> void:
	var safeDirPath = Global.savesDirectoryPath.path_join(filename.rstrip(".sf"))
	var safeFilePath = safeDirPath.path_join(filename.rstrip(".sf")+".sf")
	
	delete_directory_recurse(safeDirPath)
	check_directory(safeDirPath)
	check_directory(safeDirPath.path_join("img"))
	
	# Opens and prepares the savefile
	var saveFile = FileAccess.open(safeFilePath, FileAccess.WRITE)
	
	# Saves current scene first so it can be loaded first
	var sceneDictionary: Dictionary = {
		"scene" = Global.currentScene
	}
	save_line(saveFile, safeDirPath, sceneDictionary)
	
	# Loads up all persistent nodes in the scene (and globals)
	var persistentNodes = get_tree().get_nodes_in_group("Persistent")
	for node in persistentNodes:
		# Check the node has a save function.
		if !node.has_method("saving"):
			printerr("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
			
		# Calls for node's saving method and the stores is as a line in the savefile
		save_line(saveFile, safeDirPath, node.saving())

func load_game(filename:String) -> void:
	var safeDirPath = Global.savesDirectoryPath.path_join(filename.rstrip(".sf"))
	var safeFilePath = safeDirPath.path_join(filename)
	
	# Checks if savefile exists
	if not FileAccess.file_exists(safeFilePath):
		printerr("Load game method cannot locate given save file: "+filename)
		return
	
	# Opens savefile
	var saveFile = FileAccess.open(safeFilePath, FileAccess.READ)
	
	# Retrives first json line that should be the scene
	var data = load_line(saveFile,safeDirPath)
	
	# Loads current scene
	if not data.has("scene"):
		printerr("Savefile doesn't have a scene to load.")
		return
	
	# Starts process for loading a scene
	change_scene(data["scene"])
	# Waits till the scene loads
	await Signals.scene_loaded
	
	# Loads up all persistent nodes in the scene (and globals)
	var persistentNodes = get_tree().get_nodes_in_group("Persistent")
	
	while saveFile.get_position() < saveFile.get_length():
		data = load_line(saveFile,safeDirPath)
	
		if not data.has("nodepath"):
			printerr("Loaded entry has no nodepath")
			continue
		
		if data.has("persistent"):
			for i in max(persistentNodes.size()-1,1):
				if data["nodepath"] == String(persistentNodes[i].get_path()):
					persistentNodes[i].loading(data)
					persistentNodes.pop_at(i)
					break
		else:
			if data.has("node"):
				var node = load(data["node"])
				node = node.instantiate()
				var parent = get_node(data["parent"])
				parent.add_child(node)
				node.loading(data)
			
	Signals.emit_signal("game_loaded")
	
func delete_savefile(filename:String) -> void:
	delete_directory_recurse(Global.savesDirectoryPath.path_join(filename.rstrip(".sf")))

"""
--- Persistence Methods
"""
func saving() -> Dictionary:
	var output: Dictionary = {
		"persistent": true,
		"nodepath": get_path(),
		"parent": get_parent().get_path(),
	}
	return output

func loading(input: Dictionary) -> bool:
	return true
