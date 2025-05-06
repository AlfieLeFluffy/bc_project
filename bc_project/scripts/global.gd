extends Node

"""
--- GLobal Variables and Constants
"""
#region Timeshift Variables
## A variable holding the current active timeline instance 
var currentTimeline: Timeline = Timeline.new()
#endregion

#region Character Variables
## A variable holding the player character node
@onready var playerCharacterNode: Node = get_tree().get_first_node_in_group("Player")
## A constant holding the player character name
const PLAYER_CHARACTER_NAME = "Alfie"
#endregion

#region Group Name Constants
## A constant holding the camera focus global group name
const CAMERA_FOCUS_GROUP_NAME = "CameraFocus"
#endregion

#region Board Variables and Constants
## A variable holding the reference to the current active board element
var Active_Interactive_Item

## A variable holding a dictionary of all board elements
var board_elements: Dictionary
## A variable holding a dictionary of all board connections
var line_elements: Dictionary
#endregion

#region Scene Constants
## A variable holding the name of the current scene
var currentScene: String
## A constant dictionary holding all possible scene to load
const SCENE_PATHS: Dictionary = {
	"title_screen": "res://scenes/menus/title_screen/title_screen.tscn",
	"main_menu": "res://scenes/menus/main_menu.tscn",
	"test_level": "res://scenes/levels/test_level.tscn"
}
## A constant holding name of all non-gameplay scene names
const NON_GAMEPLAY_SCENE_NAMES: Array[String] = ["MainMenuRoot", "TitleScreen"]
#endregion

"""
--- Color Constants
"""
#region Color Constants
## A constant holding a Color reference used for white
const color_White: Color = Color("e1f6fa")
## A constant holding a Color reference used for bright text
const color_TextBright: Color = Color("a2ebfa")
## A constant holding a Color reference used for highlighted text
const color_TextHighlight: Color = Color("5fcfe6")
## A constant holding a Color reference used for highlighting
const color_Highlight: Color = Color("b334a4")
## A constant holding a Color reference used for brighter backgrounds
const color_MediumBackground: Color = Color("373747")
## A constant holding a Color reference used for darker backgrounds
const color_DarkBackground: Color = Color("2c2c39")
#endregion


"""
--- Setup Methods
"""
#region Setup Methods
func _ready() -> void:
	
	# Added group tag for persistence purposes
	add_to_group("Persistent")
	PersistenceController.s_SceneLoaded.connect(setup_scene_variables)
#endregion

"""
--- Runtime Methods
"""
#region Scene Methdos
## A method used to find the player character node once a scene loads
func setup_scene_variables() -> void:
	playerCharacterNode = get_tree().get_first_node_in_group("Player")
#endregion



#region File and Directory Manipulation Methods
## A method that checks if a directory exists and creates one if not [br]
##
## - [param directory] is a [String] name of the directory in question
func check_create_directory(directory:String) -> void:
	var dir = DirAccess.open(directory)
	if not dir:
		DirAccess.make_dir_absolute(directory)


## A method that checks if a exists or not [br]
##
## - [param filepath] is a [String] file path of the file in question
func check_file_exists(filepath:String) -> bool:
	return FileAccess.file_exists(filepath)


## A method that deletes a directory with all its contents [br]
##
## - [param directoryPath] is a [String] name of the directory in question
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
#endregion

"""
--- Persistence Methods
"""
#region Persistence Methods
func saving() -> Dictionary:
	var output: Dictionary = {
		"persistent": true,
		"nodepath": get_path(),
		"parent": get_parent().get_path(),
	}
	board_elements.clear()
	line_elements.clear()
	return output

func loading(input: Dictionary) -> bool:
	return true
#endregion
