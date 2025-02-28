extends Node

"""
--- GLobal variables
"""
# Veriables used in timeline hoping and UI elements
var Timeline = "___"

var TimelineShiftReady = true
const TIMELINE_TIMEOUT = 1.0
const TIMELINE_SHIFT_OFFSET = 0.2

# Main character info
var MainCharacterName = "Alfie"

# Veriables used in board control
var Active_Interactive_Item

# Board elements and lines
var board_elements: Dictionary
var line_elements: Dictionary

const BOARD_LINE_OFFSET: Vector2 = Vector2(-14,-14)

# Interactable variables
var interactive_radius_name = "interactRadius"

const MaxSFXSounds:int = 5

const savesDirectoryPath = "user://saves"

"""
--- Scene variables
"""

var currentScene: String
const scenePaths: Dictionary = {
	"main_menu": "res://scenes/menus/main_menu.tscn",
	"test_level": "res://scenes/levels/test_level.tscn"
}
const nongameplayScenes: Array[String] = ["MainMenu"]

"""
--- Setup Methods
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Added group tag for persistence purposes
	add_to_group("Persistent")

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
