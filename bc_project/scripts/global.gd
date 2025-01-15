extends Node

"""
--- GLobal variables
"""

# Variable used to set the next scene to load
var NextScene = ""

# Veriables used in timeline hoping and UI elements
var Timeline = "000"
var TimelineIndex = 0

var TimelineShiftReady = true
const TIMELINE_TIMEOUT = 1.0

# Veriables used in cases
var Case = "000"
var CaseIndex = 0

# Main character info
var MainCharacterName = "Alfie"

# Veriables used in board control
var Active_Board_Element
var Active_Interactive_Item

# Board elements and lines
var board_elements: Dictionary
var line_elements: Dictionary

# Focus variables
var FocusSet = false

# Interactable variables
var interactive_radius_name = "interactRadius"
enum help_signal_type {INTERACTIVE,DELETEELEMENT,DOOR,TALK}

const MaxSFXSounds:int = 5

"""
--- Setup functions
"""

func _ready() -> void:
	DialogueManager.connect("dialogue_ended",release_focus)

"""
--- Input map functions
"""

func get_input_key(inputName) -> String:
	var output = InputMap.action_get_events(inputName)[0].as_text().split("(")[0]
	return output.left(output.length()-1)

"""
--- Focus functions
"""

func release_focus(resource = null) -> void:
	if FocusSet:
		get_viewport().gui_release_focus()
		Global.FocusSet = false
	
