extends Node

# Game state variable
var InMenu = false

# Variable used to set the next scene to load
var NextScene = ""

# Veriables used in timeline hoping and UI elements
var Timeline = "000"
var TimelineIndex = 0

# Veriables used in cases
var Case = "000"
var CaseIndex = 0

func OpenMenu() -> void:
	InMenu = true
	
func CloseMenu() -> void:
	InMenu = false
