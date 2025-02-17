extends Node

"""
--- GLobal variables
"""

# Veriables used in timeline hoping and UI elements
var Timeline = "001"
var TimelineIndex = 0

var TimelineShiftReady = true
const TIMELINE_TIMEOUT = 1.0

# Veriables used in cases
var Case = "001"
var CaseIndex = 0

# Main character info
var MainCharacterName = "Alfie"

# Veriables used in board control
var activeElement
var Active_Interactive_Item

# Board elements and lines
var board_elements: Dictionary
var line_elements: Dictionary

# Interactable variables
var interactive_radius_name = "interactRadius"
enum help_signal_type {INTERACTIVE,DELETEELEMENT,DOOR,TALK}

const MaxSFXSounds:int = 5

"""
--- Scene variables
"""

const scene_paths: Dictionary = {
	"main_menu": "res://scenes/menus/main_menu.tscn",
	"test_level": "res://scenes/levels/test_level.tscn"
}

"""
--- Setup functions
"""
func _ready() -> void:
	pass
