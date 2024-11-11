extends Node

# Game state variable
var InMenu = false
var MenuLock = false
var MenuCounter = 0

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

# Veriables used in board control
var Active_Board_Element
var Active_Interactive_Item

# Board elements and lines
var array_board_elements = []
var array_line_elements = []

# Focus variables
var FocusSet = false

# Interactable variables
var interactive_radius_name = "interactRadius"
enum help_signal_type {interactive,deleteElement,door}

func open_menu() -> void:
	InMenu = true
	MenuCounter += 1
	
func close_menu() -> void:
	MenuCounter -= 1
	if MenuCounter <= 0:
		MenuCounter = 0
		InMenu = false

func get_input_key(inputName) -> String:
	var output = InputMap.action_get_events(inputName)[0].as_text().split("(")[0]
	return output.left(output.length()-1)

func release_focus() -> void:
	if FocusSet:
		get_viewport().gui_release_focus()
		Global.FocusSet = false
	
