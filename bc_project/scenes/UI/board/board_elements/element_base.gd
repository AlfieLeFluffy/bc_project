extends Control

"""
--- Runtime Variables
"""
var active = false
var dragged = false

var elementName: String
var elementColor: Color = Color.WHITE
var mouseOffset: Vector2

@onready var parent: Node = get_parent()
@onready var boardSize: Vector2 = parent.get_node("BoardBackground").size

@onready var header: Node = $Stack/Header
@onready var headerLabel: Label = header.get_node("ElementLabel")
@onready var content: Node = $Stack/Content

"""
--- Setup Methods
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_element_special()

func setup_element(elementName:String, elementTimeline:String, elementTexture,elementDescription:String) -> void:
	pass

func setup_element_special() -> void:
	pass

"""
--- Runtime Methods
"""
func _gui_input(event: InputEvent) -> void:
	if active and event.is_action_pressed("drag_board_element"):
		mouseOffset = position - get_global_mouse_position()
		dragged = true
	elif event.is_action_released("drag_board_element"):
		dragged = false

func _unhandled_input(event: InputEvent) -> void:
	if active and event.is_action("delete_board_element"):
		delete_element()

func _physics_process(delta: float) -> void:
	if visible and dragged:	
		position = get_global_mouse_position() + mouseOffset
		restrain_element()

func delete_element() -> void:
	GameController.release_focus()
	Signals.emit_signal('delete_board_element',self)
	get_viewport().set_input_as_handled()

"""
--- Restrain on Board Methods
"""
func restrain_element() -> void:
	position.x = max(position.x,0)
	position.y = max(position.y,0)
	position.x = min(position.x,boardSize.x - self.size.x)
	position.y = min(position.y,boardSize.y - self.size.y)

"""
--- Input Signal Methods
"""

func _on_delete_button_pressed() -> void:
	delete_element()

func _on_mouse_entered() -> void:
	active = true
	Signals.emit_signal("set_active_element",self)
	Signals.emit_signal("input_help_set",GameController.get_input_key_list("delete_board_element"),"REMOVE_BOARD_ELEMENT_INPUT_HELP")

func _on_mouse_exited() -> void:
	active = false
	Signals.emit_signal("set_active_element",null)
	Signals.emit_signal("input_help_delete","REMOVE_BOARD_ELEMENT_INPUT_HELP")
