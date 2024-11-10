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
	Global.array_board_elements.append(board_element_instance)
	get_parent().add_child(board_element_instance)
	var random_offset = Vector2(rng.randi_range(-100,100),rng.randi_range(-100,100))
	board_element_instance.position = Vector2(get_parent().get_node("BoardBackground").size/2+random_offset)
	board_element_instance = null
	
func create_note() -> void:
	board_element_instance = note_element.instantiate()
	finalize_element()
	
func create_item(_texture, _label, _text) -> void:
	board_element_instance = item_element.instantiate()
	board_element_instance.texture = _texture
	board_element_instance.label = _label
	board_element_instance.text = _text
	finalize_element()

func delete_board_element(element) -> void:
	var index = Global.array_board_elements.find(element)
	var list = []
	for line in Global.array_line_elements:
		if line.board_element_0 == element or line.board_element_1 == element:
			list.append(line)
	for line in list:
		Signals.emit_signal('delete_line',line)
	Global.array_board_elements[index].queue_free()
	Global.array_board_elements.remove_at(index)
	Signals.emit_signal("help_text_toggle","deleteElement",0)
