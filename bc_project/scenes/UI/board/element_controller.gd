class_name ElementControler extends Node

"""
--- Scene Preloads
"""
# Board ELements preloaded for instantiation
const boardPreload = preload("res://scenes/UI/board/board_elements/element_base.tscn")
const preloadNoteElement = preload("res://scenes/UI/board/board_elements/element_note.tscn")
const preloadObjectElement = preload("res://scenes/UI/board/board_elements/element_object.tscn")
const preloadTextElement = preload("res://scenes/UI/board/board_elements/element_text.tscn")

"""
--- Runtime Variables
"""
var instance

"""
--- Setup Methods
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.connect('create_board_element', create_board_element)
	Signals.connect('delete_board_element', delete_board_element)


"""
--- Element Managment Methods
"""
func create_board_element(elementType: BoardElementResource.elementType,elementName:String, elementTimeline:String, elementTexture,elementDescription:String) -> void:
	if check_element(elementName + elementTimeline):
		return
	match elementType:
		BoardElementResource.elementType.NOTE:
			create_note()
		BoardElementResource.elementType.OBJECT:
			create_object(elementName,elementTimeline,elementTexture,elementDescription)
		BoardElementResource.elementType.TEXT:
			create_text(elementName,elementTimeline,elementTexture,elementDescription)
		BoardElementResource.elementType.PROFILE:
			create_profile(elementName,elementTimeline,elementTexture,elementDescription)

func setup_instance(label:String, timeline:String) -> void:
	instance.elementName = label+timeline
	Global.board_elements[instance.elementName] = instance
	get_parent().add_child(instance)

func finalize_element() -> void:
	AudioManager.play_sound("ding")
	var offset = Vector2(randi_range(200,-200),randi_range(200,-200))
	instance.position = Vector2(get_parent().get_node("BoardBackground").size/2+offset)

func create_note() -> void:
	var noteName = "note"+Global.Timeline
	instance = preloadNoteElement.instantiate()
	instance.elementName = noteName
	Global.board_elements[instance.elementName] = instance
	finalize_element()
	
func create_object(label, timeline, texture, description) -> void:
	instance = preloadObjectElement.instantiate()
	setup_instance(label, timeline)
	instance.setup_element(label,timeline,texture,description)
	finalize_element()

func create_text(label, timeline, texture, description) -> void:
	instance = preloadTextElement.instantiate()
	setup_instance(label, timeline)
	instance.setup_element(label,timeline,null,description)
	finalize_element()

func create_profile(label, timeline, texture, text) -> void:
	pass


func delete_board_element(element) -> void:
	for lineKey in Global.line_elements.keys():
		if lineKey.contains(element.elementName):
			Signals.emit_signal('delete_board_line',Global.line_elements[lineKey])
	Global.board_elements.erase(element.elementName)
	element.queue_free()
	Signals.emit_signal("input_help_delete","REMOVE_BOARD_ELEMENT_INPUT_HELP")

"""
--- Element Creation Methods
"""
func check_element(key:String) -> bool:
	if Global.board_elements.has(key):
		return true
	return false

"""
--- Input Signal Methods
"""
func _on_button_symbol_plus_pressed() -> void:
	create_note()
