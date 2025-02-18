extends "res://scenes/UI/board/board_elements/element_base.gd"

"""
--- Runtime Variables
"""
var texture
var label: String
var text: String
var timeline: String

"""
--- Setup Methods
"""
func element_setup() -> void:
	if elementName:
		name = elementName
	if texture:
		$ItemTexture.texture = texture
	if label:
		$ItemLabel.text = label
	if text:
		$RichTextLabel.text = text

"""
--- Persistence Methods
"""
func saving() -> Dictionary:
	var output: Dictionary = {
		"node": "res://scenes/UI/board/board_elements/element_item.tscn",
		"filepath": get_path(),
		"parent": get_parent().get_path(),
		"name": name,
		"elementName": elementName,
		"posX": position.x,
		"posY": position.y,
		"label": label,
		"text": text,
		"timeline": timeline
	}
	return output

func loading(input: Dictionary) -> bool:
	name = input["name"]
	elementName = input["elementName"]
	Global.board_elements[elementName] = self
	position.x = input["posX"]
	position.y = input["posY"]
	label = input["label"]
	text = input["text"]
	timeline = input["timeline"]
	element_setup()
	return true
