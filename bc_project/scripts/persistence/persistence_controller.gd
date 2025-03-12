extends Node

#region Preloads and Constants
const preloadPersistenceMenu = preload("res://scripts/persistence/persistence_menu.tscn")

const savefileFolderPath: String = "user://saves"
#endregion

#region Signals
signal openPersistenceMenu(mode)

signal saveGame(filename)
signal loadGame(filename)

signal deleteSavefile(filename)
signal deleteProfileSavefiles(id)
#endregion

#region Setup Methods
func _ready() -> void:
	openPersistenceMenu.connect(open_persistence_menu)
	saveGame.connect(save_game)
	loadGame.connect(load_game)
	deleteSavefile.connect(delete_savefile)
	deleteProfileSavefiles.connect(delete_profile_savefiles)
	
	GameController.profileLoaded.connect(check_profile_savefile_folder)
#endregion

#region Folder and File Path Methods
func create_profile_savefile_folderpath(_id: String)-> String:
	return savefileFolderPath.path_join(_id)
	
func check_profile_savefile_folder() -> void:
	if GameController.profile:
		check_profile_folder_by_id(GameController.profile.id)

func check_profile_folder_by_id(_id: String) -> void:
	Global.check_create_directory(create_profile_savefile_folderpath(_id))

func get_profile_savefile_count(_id: String) -> int:
	var folderpath: String = create_profile_savefile_folderpath(_id)
	if not DirAccess.dir_exists_absolute(folderpath):
		printerr("Error: Could not get savefile count for profile '%s' as the savefile folder does not exist." % _id)
		return 0
	var count = DirAccess.get_directories_at(folderpath).size()
	return count
#endregion

#region Persistence Menu Methods
# Opens persistence menu either in save or load mode
func open_persistence_menu(mode: PersistenceMenu.modeEnum) -> void:
	if mode > 1 or mode < 0:
		printerr("Wrong Persistence Mode Parameter")
		return
	var menu = preloadPersistenceMenu.instantiate()
	menu.mode = mode
	get_tree().current_scene.add_child(menu)
	menu.layer = 100
	Signals.emit_signal("menu_clear")
#endregion

#region Saving and Loading Images Methods

# Saves an image in a dictionary into the img directory inside a savefile and sets flag to load it once loading
func save_img(key:String ,safeDirPath:String, dictionary:Dictionary) -> void:
	var imageName: String = str(dictionary[key].get_rid())
	var imagePath: String = safeDirPath.path_join("img").path_join(imageName)+".png"
	dictionary[key].get_image().save_png(imagePath)
	dictionary[key] = imageName

# Loads an image from the img directory if given flag is present in dictionary
func load_img(key, safeDirPath:String, dictionary: Dictionary) -> void:
	if not dictionary[key]:
		return
	var imagePath: String = safeDirPath.path_join("img").path_join(dictionary[key])+".png"
	if FileAccess.file_exists(imagePath):
		var image: Image = Image.load_from_file(imagePath)
		var texture: ImageTexture = ImageTexture.create_from_image(image)
		dictionary[key] = texture
	else:
		dictionary[key] = false
#endregion

#region Saving and Loading Single JSON Line Methods

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
#endregion

#region Save and Load Game Methods
func save_game(filename:String) -> void:
	var folderpath: String = PersistenceController.create_profile_savefile_folderpath(GameController.profile.id)
	var safeDirPath = folderpath.path_join(filename.rstrip(".sf"))
	var safeFilePath = safeDirPath.path_join(filename.rstrip(".sf")+".sf")
	
	Global.delete_directory_recurse(safeDirPath)
	Global.check_create_directory(safeDirPath)
	Global.check_create_directory(safeDirPath.path_join("img"))
	
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
	var folderpath: String = PersistenceController.create_profile_savefile_folderpath(GameController.profile.id)
	var safeDirPath = folderpath.path_join(filename.rstrip(".sf"))
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
	GameController.change_scene(data["scene"])
	# Waits till the scene loads
	await GameController.sceneLoaded
	
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
			
	GameController.gameLoaded.emit()
#endregion
	
#region Delete Savefiles and Profile Savefiles Methods
func delete_savefile(filename:String) -> void:
	var folderpath: String = PersistenceController.create_profile_savefile_folderpath(GameController.profile.id)
	Global.delete_directory_recurse(folderpath.path_join(filename.rstrip(".sf")))
	
func delete_profile_savefiles(_id:String) -> void:
	Global.delete_directory_recurse(create_profile_savefile_folderpath(_id))
#endregion
