extends "res://scenes/UI/board/board_elements/element_base.gd"

"""
--- Runtime Variables
"""
var label
var timeline

"""
--- Setup Methods
"""
func element_setup() -> void:
	pass

"""
--- Persistence Methods
"""
func saving() -> Dictionary:
	var output: Dictionary = {
		"node": "res://scenes/UI/board/board_elements/element_note.tscn",
		"nodepath": get_path(),
		"parent": get_parent().get_path(),
		"name": name,
		"elementName": elementName,
		"posX": position.x,
		"posY": position.y,
		"noteName": $NoteName.text,
		"noteText": $NoteText.text
	}
	return output

func loading(input: Dictionary) -> bool:
	name = input["name"]
	elementName = input["elementName"]
	Global.board_elements[elementName] = self
	position.x = input["posX"]
	position.y = input["posY"]
	$NoteName.text = input["noteName"]
	$NoteText.text = input["noteText"]
	return true
