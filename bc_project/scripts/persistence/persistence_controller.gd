extends Node
## The Persitence Controller autoload script 


#region Preloads and Setup Constant/Variables
## A constant holding the preloaded reference for the [PersitenceMenu]
const PRELOAD_PERSISTENCE_MENU = preload("res://scripts/persistence/persistence_menu.tscn")
## A constant holding the preloaded reference for the [SavingAnimation]
const PRELOAD_SAVING_ANIMATION = preload("res://scripts/persistence/saving_animation.tscn")

## A constant holding the master save file folder path
const MASTER_SAVEFILE_FOLDER_PATH: String = "user://saves"
## A constant holding the string format for autosave file name
const AUTOSAVE_FILENAME_STRING_FORMAT: String = "autosave_%s"

## A variables holding reference to the callable method that gets the scene identification for later loading.
var GET_SCENE_IDENTIFICATION: Callable = GameController.get_current_scene
## A variables holding reference to the callable method that should be called when changing scenes.
var SCENE_LOADING_METHOD: Callable = GameController.change_scene
## A variables holding reference to the callable method that adds and positions the persistence menu to the scene tree.
var OPEN_MENU_METHOD: Callable = GameController.open_popup_menu
#endregion

#region Signals
## Signal for notifying [PersistenceController] to open a settings menu.[br]
##
## - [param mode] is a specification in which mode should the persistence menu open. 
## The mode enum is kept inside [PersistenceMenu] class and can be either SAVE or LOAD.
signal s_PersistenceMenuOpen(mode: PersistenceMenu.e_Mode)

## Signal for notifying [PersistenceController] to start the saving process that should result in a specified savefile.[br]
##
## - [param profileID] specifies which profile save file directory should be used.[br]
## - [param filename] specifies which savefile should be interacted with.[br]
signal s_SaveGame(profileID: String, filename: String)
## Signal for notifying [PersistenceController] to start the saving process without specifying the savefile name.[br]
## A savefile name will be genereated instead. [br]
##
## - [param profileID] specifies which profile save file directory should be used.[br]
signal s_AutosaveGame(profileID: String)
## Signal for notifying [PersistenceController] to start the loading process with a specified savefile.
##
## - [param profileID] specifies which profile save file directory should be used.[br]
## - [param filename] specifies which savefile should be interacted with.
signal s_LoadGame(profileID: String, filename: String)

## Signal for notifying [PersistenceController] to delete a specified savefile.[br]
##
## - [param profileID] specifies which profile save file directory should be used.[br]
## - [param filename] specifies which savefile should be interacted with.
signal s_SavefileDelete(profileID: String, filename: String)
## Signal for notifying [PersistenceController] to delete all savefiles of a specified profile.[br]
##
## - [param profileID] specifies which profile should be interacted with.
signal s_SavefilesProfileDelete(profileID: String)
## Signal for notifying [PersistenceController] to check existence of profile savefile folder.[br]
##
## - [param profileID] specifies which profile should be interacted with.
signal s_CheckProfileSavefileFolder(profileID: String)

## Signal that notifies scripts that a new current scene was loaded. 
## This is used to update all scene dependent mechanics like UI.
signal s_SceneLoaded()
## Signal that notifies scripts that a game state was loaded.
## This is used during the loading process to notify scripts that the loading mechanic changed the game state from the initial. 
signal s_GameLoaded()
#endregion

#region Setup Methods
## Persistence Controller initial setup 
func _ready() -> void:
	s_PersistenceMenuOpen.connect(open_persistence_menu)
	s_SaveGame.connect(save_game)
	s_AutosaveGame.connect(autosave_game)
	s_LoadGame.connect(load_game)
	s_SavefileDelete.connect(delete_savefile)
	s_SavefilesProfileDelete.connect(delete_profile_savefiles)
	s_CheckProfileSavefileFolder.connect(check_profile_folder_by_id)
#endregion



#region Folder and File Path Methods
## A method for checking if a profile has a savefile folder. If a profile savefile folder
## does not exist it creates one. [br]
##
## - [param profileID] is a [String] argument which denotes the folder name.
func check_profile_folder_by_id(profileID: String) -> void:
	Global.check_create_directory(create_profile_savefile_folderpath(profileID))

## A method that creates a profile savefile folder path. [br]
##
## - [param profileID] is a [String] argument which denotes the folder name.
func create_profile_savefile_folderpath(profileID: String)-> String:
	return MASTER_SAVEFILE_FOLDER_PATH.path_join(profileID)

## A method that counts savefile in a specific profile savefile folder. [br]
##
## - [param profileID] is a [String] argument which denotes the folder name.
func get_profile_savefile_count(profileID: String) -> int:
	var folderpath: String = create_profile_savefile_folderpath(profileID)
	if not DirAccess.dir_exists_absolute(folderpath):
		printerr("Error: Could not get savefile count for profile '%s' as the savefile folder does not exist." % profileID)
		return 0
	var count = DirAccess.get_directories_at(folderpath).size()
	return count
#endregion



#region Persistence Menu Methods
## A method that opens the [PersistanceMenu]. This menu is opened as part of the [PopupMenuController]
## and requires a mode to be specified. The menu is create generally for both saving and loading the game
## which is why the mode is required. [br]
##
## - [param mode] is a [PersitanceMenu] enum [e_Mode] which specifies if the menu should open for saving or loading.
func open_persistence_menu(mode: PersistenceMenu.e_Mode) -> void:
	if mode > 1 or mode < 0:
		printerr("Wrong Persistence Mode Parameter")
		return
	var percistenceMenu: PersistenceMenu = PRELOAD_PERSISTENCE_MENU.instantiate()
	percistenceMenu.mode = mode
	var popupMenu: Node = OPEN_MENU_METHOD.call(percistenceMenu)
#endregion



#region Saving and Loading Images Methods
## A method that can save a [Resource] during the process of saving the game state. 
## The method first figures out what to name the resource based on the resource's name, id or it generates
## a new id just for the purpose of saving the resource.
## Once the resource has a name it is save within the 'resource' folder inside the save file folder.
## The resource is then replaced within the save [param dictionary] with a reference to the file. [br]
##
## - [param key] is a [String] argument that identifies which resource within the [param dicrionary] is currently worked with. [br]
## - [param savefileDirectoryPath] is a [String] argument with the folder path to the root folder of the save file. [br]
## - [param dictionary] is the [Dictionary] argument which holds all resource of the persitent aspect.  [br]
func save_resource(key:String, savefileDirectoryPath:String, dictionary:Dictionary) -> void:
	## A resource filename setup
	var resourceFilename: String
	if "name" in dictionary[key]:
		resourceFilename = str(dictionary[key].name)+".tres"
	elif "id" in dictionary[key]:
		resourceFilename = str(dictionary[key].id)+".tres"
	else:
		resourceFilename = str(randi_range(00000,99999))+".tres"
	
	## Saving the resource with error catching
	var resourcePath: String = savefileDirectoryPath.path_join("resources").path_join(resourceFilename)
	var error = ResourceSaver.save(dictionary[key],resourcePath)
	if error:
		printerr("Error: During saving of resource '%s' if path '%s' occured error: " % [resourceFilename,resourcePath] + str(error))
		dictionary.erase(key)
		return
	
	## If saving was succesfull the resource filename is saved over the resource for later loading.
	dictionary[key] = resourceFilename

## A method loads a resource during the loading process. If the dictionary does not contain the key or the key is
## empty the loading is aborted. Otherwise the key is taken as the filename of the [Resource] file to be loaded.
## If the resource is sucesfully loaded from the resources folder inside the root savefile folder then the method
## assigns the resource instead of the filename under the key inside the [param dictionary]. If there is a problem during loading
## then the key is erased from the [param dictionary]. [br]
##
## - [param key] is a [String] argument that identifies which resource within the [param dicrionary] is currently worked with. [br]
## - [param savefileDirectoryPath] is a [String] argument with the folder path to the root folder of the save file. [br]
## - [param dictionary] is the [Dictionary] argument which holds all resource of the persitent aspect.  [br]
func load_resource(key: String, savefileDirectoryPath:String, dictionary: Dictionary) -> void:
	if not dictionary.has(key):
		return
	if not dictionary[key]:
		return
	
	var resourceFilename: String = savefileDirectoryPath.path_join("resources").path_join(dictionary[key])
	dictionary[key] = ResourceLoader.load(resourceFilename)
	
	if dictionary[key] is int:
		dictionary.erase(key)
#endregion



#region Saving and Loading Single JSON Line Methods
## A method that takes one input dictionary contaning all information about a object that need to be stored, 
## checks and saves any resources of said object and then reformats the dictionary into JSON format line
## and stores it inside the save file. [br]
## Simplified it saves one object into the save file. [br]
##
## - [param savefile] is a [FileAccess] argument that holds the refenrece to the open and currently in use save file. [br]
## - [param savefileDirectoryPath] is a [String] argument with the folder path to the root folder of the save file. [br]
## - [param dictionary] is the [Dictionary] argument which holds all information of the persitent aspect that needs to be stored.  [br]
func save_line(savefile: FileAccess, savefileDirectoryPath:String, dictionary:Dictionary) -> void:
	if dictionary.has("resources"):
		if not dictionary["resources"] is Dictionary:
			return
		for resource in dictionary["resources"].keys():
			save_resource(resource,savefileDirectoryPath,dictionary["resources"])
	var json = JSON.stringify(dictionary)
	savefile.store_line(json)

## Takes one line from the save file, converts the JSON format into a dictionary, checks and loads any resources 
## object might have and returns the complete dictionary back. [br]
## Simplified it takes one line from the save file and reverses the saving process. [br]
##
## - [param savefile] is a [FileAccess] argument that holds the refenrece to the open and currently in use save file. [br]
## - [param savefileDirectoryPath] is a [String] argument with the folder path to the root folder of the save file. [br]
func load_line(savefile: FileAccess, savefileDirectoryPath:String) -> Dictionary:
	var json = savefile.get_line()
	var parse =  JSON.parse_string(json)
	
	if parse.has("resources"):
		if parse["resources"] is Dictionary: 
			for resource in parse["resources"].keys():
				load_resource(resource,savefileDirectoryPath,parse["resources"])
	return parse
#endregion



#region Save and Load Game Methods
## The main method for the saving process.[br]
## The sequence starts with saving animation and cursor setup, deletes any possible previous
## save file with the same name in the same profile and creates a base save file folder and file.
## The method then saves the current scene and then goes through all nodes inside the persistent group.
## Every node in the persistent group is saved into the save file with their resources saved into a
## separate folder inside the save file folder. Once all is saved the method ends animation and return
## cursor back to normal. [br]
##
## - [param profileID] specifies which profile save file directory should be used.[br]
## - [param filename] specifies which save file should be interacted with.
func save_game(profileID: String, filename:String) -> void:
	var animation: SavingAnimation = PRELOAD_SAVING_ANIMATION.instantiate()
	get_tree().current_scene.add_child(animation)
	Input.set_default_cursor_shape(Input.CURSOR_BUSY)
	
	var folderpath: String = create_profile_savefile_folderpath(profileID)
	var saveDirPath = folderpath.path_join(filename.rstrip(".sf"))
	var safeFilePath = saveDirPath.path_join(filename.rstrip(".sf")+".sf")
	
	Global.delete_directory_recurse(saveDirPath)
	Global.check_create_directory(saveDirPath)
	Global.check_create_directory(saveDirPath.path_join("resources"))
	
	# Opens and prepares the savefile
	var saveFile = FileAccess.open(safeFilePath, FileAccess.WRITE)
	
	# Saves current scene first so it can be loaded first
	var sceneDictionary: Dictionary = {
		"scene" = GameController.get_current_scene()
	}
	save_line(saveFile, saveDirPath, sceneDictionary)
	
	# Loads up all persistent nodes in the scene (and globals)
	var persistentNodes = get_tree().get_nodes_in_group("Persistent")
	for node in persistentNodes:
		# Check the node has a save function.
		if !node.has_method("saving"):
			printerr("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
			
		# Calls for node's saving method and the stores is as a line in the savefile
		save_line(saveFile, saveDirPath, node.saving())
	
	if animation:
		animation.done = true
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

## A method that generates an autosave name before continuing as normal with save_game method.
##
## - [param profileID] specifies which profile save file directory should be used.[br]
func autosave_game(profileID: String) -> void:
	save_game(profileID, AUTOSAVE_FILENAME_STRING_FORMAT % [Time.get_datetime_string_from_system().replace("-","_").replace(":","_")])

## The main method for the loading process.[br]
## The method first sets up reused [String] variables and checks if the given save file exists.
## If the save file exists the script opens it, reads the first line and initiates through the
## declared callable a scene change. Once the scene is loaded the method then goes through all lines
## within the file, either find or creates the saved node and initiates the nodes loading method. 
## Once all lines have been loaded the script emits a signal to notify the game a game state finished loading[br]
##
## - [param profileID] specifies which profile save file directory should be used.[br]
## - [param filename] specifies which save file should be interacted with.
func load_game(profileID: String, filename:String) -> void:
	var folderpath: String = create_profile_savefile_folderpath(profileID)
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
	SCENE_LOADING_METHOD.call(data["scene"])
	# Waits till the scene loads
	await s_SceneLoaded
	
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
			
	s_GameLoaded.emit()
#endregion



#region Delete Savefiles and Profile Savefiles Methods
## A method that deletes a specific savefile for a specfic profile. [br]
##
## - [param profileID] a [String] variable denoting which profile should be used.[br]
## - [param filename] a [String] variable denoting which savefile should be worked with.[br]
func delete_savefile(profileID: String, filename:String) -> void:
	var folderpath: String = create_profile_savefile_folderpath(profileID)
	Global.delete_directory_recurse(folderpath.path_join(filename.rstrip(".sf")))
	
## A method that deletes all savefile for a specfic profile. [br]
##
## - [param profileID] a [String] variable denoting which profile should be used.[br]
func delete_profile_savefiles(profileID: String) -> void:
	Global.delete_directory_recurse(create_profile_savefile_folderpath(profileID))
#endregion
