extends Node2D

"""
--- Runtime Variables
"""
var color
var thickness
var lineName

var active = false
var drawing = true

var element0Name = null
var element1Name = null

var element0 = null
var element1 = null

"""
--- Runtime Methods
"""
func _input(event: InputEvent) -> void:
	if active and event.is_action_pressed("destroy_board_element") and not Global.FocusSet:
		Global.release_focus()
		Signals.emit_signal('delete_line',self)

func _process(delta: float) -> void:
	if not element0 and Global.board_elements.has(element0Name):
		element0 = Global.board_elements[element0Name]
	if not element1 and Global.board_elements.has(element1Name):
		element1 = Global.board_elements[element1Name]
	if element0:
		queue_redraw() 

func _physics_process(delta: float) -> void:
	if element1 != null and is_instance_valid(element0) and is_instance_valid(element1):
		position = (element0.position).lerp(element1.position, 0.5); 

func _draw() -> void:
	if drawing:
		draw_line(element0.position-position,$".".get_local_mouse_position(), color, thickness )
	
	if not drawing and element1:
		draw_line(element0.position-position,element1.position-position, color, thickness)

"""
--- General Methods
"""
func toggle_description() -> void:
	$ConnectionText.visible = not $ConnectionText.visible

func set_description(text) -> void:
	$ConnectionText.text = text

func toggle_edit() -> void:
	$ConnectionText.editable = not $ConnectionText.editable 

"""
--- Input Signal Methods
"""
func _on_mouse_entered() -> void:
	Signals.emit_signal("help_text_toggle",Global.help_signal_type.DELETEELEMENT,true)
	active = true

func _on_mouse_exited() -> void:
	Signals.emit_signal("help_text_toggle",Global.help_signal_type.DELETEELEMENT,false)
	active = false

func saving() -> Dictionary:
	var output: Dictionary = {
		"node": "res://scenes/UI/board/board_elements/connection_base.tscn",
		"filepath": get_path(),
		"parent": get_parent().get_path(),
		"name": name,
		"lineName": lineName,
		"posX": position.x,
		"posY": position.y,
		"color": color.to_html(),
		"thickness": thickness,
		"visible": $ConnectionText.visible,
		"text": $ConnectionText.text,
		"editable": $ConnectionText.editable,
		"element0": element0.elementName,
		"element1": element1.elementName,
	}
	return output

func loading(input: Dictionary) -> bool:
	name = input["name"]
	lineName = input["lineName"]
	Global.line_elements[lineName] = self
	position.x = input["posX"]
	position.y = input["posY"]
	drawing = false
	color = Color.html(input["color"]) 
	thickness = input["thickness"]
	$ConnectionText.visible = input["visible"]
	$ConnectionText.text = input["text"]
	$ConnectionText.editable = input["editable"]
	element0Name = input["element0"]
	element1Name = input["element1"]
	return true
