extends "res://scenes/UI/board/board_elements/element_base.gd"

"""
--- Runtime Variables
"""
var label: String
var timeline: String
var texture
var description: String

@onready var contentTexture: TextureRect = content.get_node("ObjectTexture")
@onready var contentDescription: RichTextLabel = content.get_node("ObjectDescription")


"""
--- Setup Methods
"""
func setup_element(elementName:String, elementTimeline:String, elementTexture,elementDescription:String) -> void:
	label = elementName
	timeline = elementTimeline
	texture = elementTexture
	description  = elementDescription
	
	name = elementName  + timeline
	contentTexture.texture = texture
	headerLabel.text = tr(label) + " : " + timeline
	contentDescription.text = "[center]"+tr(description)

func setup_element_special() -> void:
	elementColor = Color.BLUE

"""
--- Persistence Methods
"""
func saving() -> Dictionary:
	var output: Dictionary = {
		"node": "res://scenes/UI/board/board_elements/element_object.tscn",
		"nodepath": get_path(),
		"parent": get_parent().get_path(),
		"name": name,
		"elementName": elementName,
		"posX": position.x,
		"posY": position.y,
		"label": label,
		"description": description,
		"timeline": timeline,
		"img": texture
	}
	return output

func loading(input: Dictionary) -> bool:
	name = input["name"]
	elementName = input["elementName"]
	Global.board_elements[elementName] = self
	position.x = input["posX"]
	position.y = input["posY"]
	setup_element(input["label"],input["timeline"],input["img"],input["description"])
	return true
