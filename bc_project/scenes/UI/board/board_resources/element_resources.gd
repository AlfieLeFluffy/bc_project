class_name ElementResource extends Resource

"""
--- Board Element Types
"""
enum elementType {NOTE,OBJECT,TEXT,FILE,PROFILE}

const elementColor: Dictionary = {
	ElementResource.elementType.NOTE : Color.WHITE,
	ElementResource.elementType.OBJECT : Color.ROYAL_BLUE,
	ElementResource.elementType.TEXT : Color.LIME_GREEN,
	ElementResource.elementType.FILE : Color.WHITE,
	ElementResource.elementType.PROFILE : Color.WHITE,
}

"""
--- Board Element Varibles
"""
var type: elementType
var id: String
var name: String
var timeline: String
var description: String
var texture
var color: Color

func _init(_type: elementType, _name: StringName = "", _timeline: String = "", _description: String = "", _texture = null) -> void:
	type = _type
	id = create_id(_name,_timeline)
	name = _name
	timeline = _timeline
	description = _description
	texture = _texture
	color = get_color(_type)

func create_id(_name: StringName, _timeline: String) -> String:
	return _name + _timeline

func get_color(_type: elementType) -> Color:
	return elementColor[_type]
