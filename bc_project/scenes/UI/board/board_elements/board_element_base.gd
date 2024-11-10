extends Area2D

var active = false
var dragged = false

var parent
var board
var board_size

var mouse_offset

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	element_setup()
	parent = get_parent()
	board = parent.get_node("BoardBackground")
	board_size = board.size

func element_setup() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("drag_element") and active:
		dragged = true
		mouse_offset = $".".position - $".".get_global_mouse_position()
	elif event.is_action_released("drag_element"):
		dragged = false
	
	if active and event.is_action_pressed("destroy_board_element") and not Global.FocusSet:
		Global.release_focus()
		Signals.emit_signal('delete_element',self)
		
func _physics_process(delta: float) -> void:
	if Global.InMenu and visible and dragged:
		var mouse_possition = get_global_mouse_position()
		position = mouse_possition + mouse_offset
		restrain_element()

func restrain_element() -> void:
	if position.x > board_size.x - $element_texture.texture.get_height()/2:
		position.x = board_size.x - $element_texture.texture.get_height()/2
	
	if position.x < $element_texture.texture.get_height()/2 :
		position.x = $element_texture.texture.get_height()/2
	
	if position.y > board_size.y -$element_texture.texture.get_width()/2:
		position.y = board_size.y -$element_texture.texture.get_width()/2
		
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

func _on_mouse_shape_entered(shape_idx: int) -> void:
	Global.Active_Board_Element = $"."
	Signals.emit_signal("help_text_toggle","deleteElement",1)
	active = true


func _on_mouse_shape_exited(shape_idx: int) -> void:
	Global.Active_Board_Element = null
	Signals.emit_signal("help_text_toggle","deleteElement",0)
	active = false
