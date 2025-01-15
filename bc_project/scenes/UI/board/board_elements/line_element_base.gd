extends Node2D

var color
var thickness
var lineName

var active = false
var drawing = true

var board_element_0 = null
var board_element_1 = null

func _process(delta: float) -> void:
	queue_redraw() 

func _physics_process(delta: float) -> void:
	if board_element_1 != null and is_instance_valid(board_element_0) and is_instance_valid(board_element_1):
		position = (board_element_0.position).lerp(board_element_1.position, 0.5); 

func _draw() -> void:
	if drawing:
		draw_line(board_element_0.position-position,$".".get_local_mouse_position(), color, thickness )
	
	if not drawing and is_instance_valid(board_element_0) and is_instance_valid(board_element_1):
		draw_line(board_element_0.position-position,board_element_1.position-position, color, thickness)

func toggle_description() -> void:
	$ConnectionText.visible = not $ConnectionText.visible

func _input(event: InputEvent) -> void:
	if active and event.is_action_pressed("destroy_board_element") and not Global.FocusSet:
		Global.release_focus()
		Signals.emit_signal('delete_line',self)

func _on_mouse_entered() -> void:
	Signals.emit_signal("help_text_toggle",Global.help_signal_type.DELETEELEMENT,true)
	active = true

func _on_mouse_exited() -> void:
	Signals.emit_signal("help_text_toggle",Global.help_signal_type.DELETEELEMENT,false)
	active = false
