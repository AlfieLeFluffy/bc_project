extends Node

"""
--- GLobal Variables and Constants
"""
#region Timeshift Variables
# Veriables used in timeline hoping and UI elements
var currentTimeline: Timeline = Timeline.new()

const TIMELINE_TIMEOUT = 1.0
const TIMELINE_SHIFT_OFFSET = 0.2
#endregion

#region Character Variables
# Main character info
@onready var playerCharacterNode: Node = get_tree().get_first_node_in_group("Player")
const mainCharacterName = "Alfie"
#endregion

#region Group Name Constants
# Main character info
const cameraFocusName = "CameraFocus"
#endregion

#region Board Variables and Constants
# Veriables used in board control
var Active_Interactive_Item

# Board elements and lines
var board_elements: Dictionary
var line_elements: Dictionary

const BOARD_LINE_OFFSET: Vector2 = Vector2(-16,-16)
#endregion

#region Scene Constants
var currentScene: String
const scenePaths: Dictionary = {
	"main_menu": "res://scenes/menus/main_menu.tscn",
	"test_level": "res://scenes/levels/test_level.tscn"
}
const nongameplayScenes: Array[String] = ["MainMenuRoot"]
#endregion

"""
--- Color Constants
"""
#region Color Constants
const color_White: Color = Color("e1f6fa")
const color_TextBright: Color = Color("a2ebfa")
const color_TextHighlight: Color = Color("5fcfe6")
const color_Highlight: Color = Color("b334a4")
const color_MediumBackground: Color = Color("373747")
const color_DarkBackground: Color = Color("2c2c39")
#endregion


"""
--- Setup Methods
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Added group tag for persistence purposes
	add_to_group("Persistent")
	GameController.sceneLoaded.connect(setup_scene_variables)

"""
--- Runtime Methods
"""
func setup_scene_variables() -> void:
	playerCharacterNode = get_tree().get_first_node_in_group("Player")

#region File and Directory Manipulation Methods
# Checks if a directory exists and creates one if not
func check_create_directory(directory:String) -> void:
	var dir = DirAccess.open(directory)
	if not dir:
		DirAccess.make_dir_absolute(directory)

# Checks if a directory exists and creates one if not
func check_file_exists(filepath:String) -> bool:
	return FileAccess.file_exists(filepath)

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
#endregion

"""
--- Persistence Methods
"""
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
