class_name ElementControler extends Node

#region Varibles, Constants and Enums
"""
--- Scene Preloads
"""
# Board ELements preloaded for instantiation
const boardPreload = preload("res://scenes/UI/board/board_elements/element_base.tscn")
const elementPreload = preload("res://scenes/UI/board/board_elements/element_base.tscn")

"""
--- Runtime Variables
"""
var instance: ElementBase
#endregion

#region Setup Methods
"""
--- Setup Methods
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.connect('create_board_element', create_board_element)
	Signals.connect('delete_board_element', delete_board_element)
#endregion


"""
--- Element Managment Methods
"""
func create_board_element(elementResource: ElementResource) -> void:
	if check_element(elementResource.name + elementResource.timeline):
		return
	create_element(elementResource)

func create_element(elementResource: ElementResource) -> void:
	instance = elementPreload.instantiate()
	instance.resource = elementResource
	setup_instance(elementResource)
	finalize_element()

func setup_instance(elementResource: ElementResource) -> void:
	Global.board_elements[elementResource.id] = instance
	get_parent().add_child(instance)

func finalize_element() -> void:
	AudioManager.play_sound("ding")
	var offset = Vector2(randi_range(200,-200),randi_range(200,-200))
	instance.position = Vector2(get_parent().get_node("BoardBackground").size/2+offset)

func delete_board_element(element) -> void:
	for lineKey in Global.line_elements.keys():
		if lineKey.contains(element.resource.id):
			Signals.emit_signal('delete_board_line',Global.line_elements[lineKey])
	Global.board_elements.erase(element.resource.id)
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
	create_element(ElementResource.new(ElementResource.elementType.NOTE,"note",Global.Timeline,"",null))
