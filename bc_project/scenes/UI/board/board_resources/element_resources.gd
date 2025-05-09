class_name ElementResource extends Resource

#region Constants
enum elementType {NOTE,OBJECT,TEXT,FILE,PROFILE,DIALOGUE}

const elementColor: Dictionary = {
	ElementResource.elementType.NOTE : Color.WHITE,
	ElementResource.elementType.OBJECT : Color.ROYAL_BLUE,
	ElementResource.elementType.TEXT : Color.LIME_GREEN,
	ElementResource.elementType.FILE : Color.DARK_RED,
	ElementResource.elementType.PROFILE : Color.WHITE,
	ElementResource.elementType.DIALOGUE : Color.DARK_VIOLET,
}

const elementContent: Dictionary = {
	ElementResource.elementType.NOTE : "res://scenes/UI/board/board_elements/elementContent/content_note.tscn",
	ElementResource.elementType.OBJECT : "res://scenes/UI/board/board_elements/elementContent/content_object.tscn",
	ElementResource.elementType.TEXT : "res://scenes/UI/board/board_elements/elementContent/content_text.tscn",
	ElementResource.elementType.FILE : "res://scenes/UI/board/board_elements/elementContent/content_file.tscn",
	ElementResource.elementType.PROFILE : "res://scenes/UI/board/board_elements/elementContent/content_profile.tscn",
	ElementResource.elementType.DIALOGUE : "res://scenes/UI/board/board_elements/elementContent/content_dialogue.tscn",
}
#endregion

#region Variables
@export var type: elementType
@export var id: String
@export var name: String
@export var timeline: String
@export var description: String
@export var texture: Texture
@export var color: Color
#endregion

#region Resource Methods
func setup(_type: elementType, _name: StringName = "", _timeline: String = "", _description: String = "", _texture = null) -> ElementResource:
	type = _type
	id = create_id(_name,_timeline)
	name = _name
	timeline = _timeline
	description = _description
	texture = _texture
	color = get_color(_type)
	return self

func create_id(_name: StringName, _timeline: String) -> String:
	return _name + _timeline

func get_color(_type: elementType) -> Color:
	return elementColor[_type]
#endregion
