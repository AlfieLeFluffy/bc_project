extends Node


var board_element_instance

var rng = RandomNumberGenerator.new()

# Board ELements preloaded for instantiation
var board_element = preload("res://scenes/UI/board/board_elements/board_element_base.tscn")
var note_element = preload("res://scenes/UI/board/board_elements/board_element_note.tscn")
var item_element = preload("res://scenes/UI/board/board_elements/board_element_item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.connect('delete_element', delete_board_element)
	Signals.connect('create_item_element', create_item)

func _on_button_symbol_plus_pressed() -> void:
	create_note()

func finalize_element() -> void:
	get_parent().add_child(board_element_instance)
	var random_offset = Vector2(rng.randi_range(-100,100),rng.randi_range(-100,100))
	board_element_instance.position = Vector2(get_parent().get_node("BoardBackground").size/2+random_offset)
	board_element_instance = null
	
func create_note() -> void:
	if check_element("note"+Global.Timeline):
		return
	board_element_instance = note_element.instantiate()
	board_element_instance.label = "note"
	board_element_instance.elementName = "note"+Global.Timeline
	Global.board_elements[board_element_instance.elementName] = board_element_instance
	finalize_element()
	
func create_item(_texture, _label, _text) -> void:
	if check_element(_label+Global.Timeline):
		return
	board_element_instance = item_element.instantiate()
	board_element_instance.texture = _texture
	board_element_instance.label = _label
	board_element_instance.text = _text
	board_element_instance.elementName = _label+Global.Timeline
	Global.board_elements[board_element_instance.elementName] = board_element_instance
	finalize_element()

func check_element(key:String) -> bool:
	if Global.board_elements.has(key):
		return true
	return false

func delete_board_element(element) -> void:
	for lineKey in Global.line_elements.keys():
		if lineKey.contains(element.elementName):
			Signals.emit_signal('delete_line',Global.line_elements[lineKey])
	Global.board_elements.erase(element.elementName)
	element.queue_free()
	Signals.emit_signal("help_text_toggle",Global.help_signal_type.DELETEELEMENT,false)
