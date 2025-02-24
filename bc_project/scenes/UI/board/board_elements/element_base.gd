extends Area2D

"""
--- Runtime Variables
"""
var active = false
var dragged = false

var elementName

var parent
var board
var boardSize
var mouseOffset

"""
--- Setup Methods
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	element_setup()
	parent = get_parent()
	board = parent.get_node("BoardBackground")
	boardSize = board.size

func element_setup() -> void:
	pass

"""
--- Runtime Methods
"""
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("drag_element") and active:
		dragged = true
		mouseOffset = $".".position - $".".get_global_mouse_position()
		get_viewport().set_input_as_handled()
	elif event.is_action_released("drag_element"):
		dragged = false
	elif active and event.is_action_pressed("destroy_board_element") and not Global.FocusSet:
		GameController.release_focus()
		Signals.emit_signal('delete_element',self)
		get_viewport().set_input_as_handled()

func _physics_process(delta: float) -> void:
	if visible and dragged:	
		var mousePossition = get_global_mouse_position()
		position = mousePossition + mouseOffset
		restrain_element()

"""
--- Restrain on Board Methods
"""
func restrain_element() -> void:
	if position.x > boardSize.x - $element_texture.texture.get_height()/2:
		position.x = boardSize.x - $element_texture.texture.get_height()/2
	
	if position.x < $element_texture.texture.get_height()/2 :
		position.x = $element_texture.texture.get_height()/2
	
	if position.y > boardSize.y -$element_texture.texture.get_width()/2:
		position.y = boardSize.y -$element_texture.texture.get_width()/2
		
	if position.y < $element_texture.texture.get_width()/2:
		position.y = $element_texture.texture.get_height()/2
"""
func _on_mouse_entered() -> void:
	Signals.emit_signal("help_text_toggle","deleteElement",1)
	active = true
	Global.Active_Board_Element = $"."

func _on_mouse_exited() -> void:
	Signals.emit_signal("help_text_toggle","deleteElement",0)
	active = false
	Global.Active_Board_Element = null
"""

"""
--- Input Signal Methods
"""
func _on_mouse_shape_entered(shape_idx: int) -> void:
	active = true
	Global.activeElement = $"."
	Signals.emit_signal("input_help_set",GameController.get_input_key_list("destroy_board_element"),"REMOVE_BOARD_ELEMENT_INPUT_HELP")

func _on_mouse_shape_exited(shape_idx: int) -> void:
	active = false
	Global.activeElement = null
	Signals.emit_signal("input_help_delete","REMOVE_BOARD_ELEMENT_INPUT_HELP")
