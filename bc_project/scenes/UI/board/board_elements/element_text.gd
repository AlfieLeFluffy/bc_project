extends ElementBase

"""
--- Runtime Variables
"""
var label: String
var timeline: String
var description: String

@onready var contentDescription: RichTextLabel = content.get_node("ObjectDescription")
"""
--- Setup Methods
"""
func setup_element(elementName:String, elementTimeline:String, elementTexture,elementDescription:String) -> void:
	label = elementName
	timeline = elementTimeline
	description  = elementDescription

func setup_text() -> void:
	name = label  + timeline
	headerLabel.text = tr(label) + " : " + timeline
	contentDescription.text = "[center]"+tr(description)

func setup_element_special() -> void:
	elementColor = Color.GREEN
	SettingsController.connect("retranslate",setup_text)

"""
--- Persistence Methods
"""
func saving() -> Dictionary:
	var output: Dictionary = {
		"node": "res://scenes/UI/board/board_elements/element_text.tscn",
		"nodepath": get_path(),
		"parent": get_parent().get_path(),
		"name": name,
		"elementName": elementName,
		"posX": position.x,
		"posY": position.y,
		"label": label,
		"description": description,
		"timeline": timeline,
	}
	return output

func loading(input: Dictionary) -> bool:
	name = input["name"]
	elementName = input["elementName"]
	Global.board_elements[elementName] = self
	position.x = input["posX"]
	position.y = input["posY"]
	setup_element(input["label"],input["timeline"],null,input["description"])
	return true
