class_name ElementControler extends Node

"""
--- Scene Preloads
"""
# Board ELements preloaded for instantiation
const boardPreload = preload("res://scenes/UI/board/board_elements/element_base.tscn")
const notePreload = preload("res://scenes/UI/board/board_elements/element_note.tscn")
const itemPreload = preload("res://scenes/UI/board/board_elements/element_item.tscn")

"""
--- Runtime Variables
"""
var instance

"""
--- Setup Methods
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.connect('delete_element', delete_board_element)
	Signals.connect('create_item_element', create_item)


"""
--- Element Managment Methods
"""
func create_note() -> void:
	var noteName = "note"+Global.Timeline
	if check_element(noteName):
		return
	
	instance = notePreload.instantiate()
	instance.elementName = noteName
	
	Global.board_elements[instance.elementName] = instance
	finalize_element()
	
func create_item(texture, label, text) -> void:
	var itemName = label+Global.Timeline
	if check_element(itemName):
		return
	
	instance = itemPreload.instantiate()
	instance.elementName = itemName
	
	instance.texture = texture
	instance.label = label
	instance.text = text
	
	Global.board_elements[instance.elementName] = instance
	finalize_element()

func finalize_element() -> void:
	get_parent().add_child(instance)
	var offset = Vector2(randi_range(200,-200),randi_range(200,-200))
	instance.position = Vector2(get_parent().get_node("BoardBackground").size/2+offset)

func delete_board_element(element) -> void:
	for lineKey in Global.line_elements.keys():
		if lineKey.contains(element.elementName):
			Signals.emit_signal('delete_line',Global.line_elements[lineKey])
	Global.board_elements.erase(element.elementName)
	element.queue_free()
	Signals.emit_signal("help_text_toggle",Global.help_signal_type.DELETEELEMENT,false)

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
