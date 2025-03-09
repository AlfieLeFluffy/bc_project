class_name ConnectionBase extends Control

"""
--- Runtime Variables
"""
var lineName : String
var description : String

var active = false

var element0:Control = null
var element0Name:String = ""
var element1:Control = null
var element1Name:String = ""

@onready var connectionLabel: Label = $HBox/Label
@onready var connectionLine: Line2D = $Line2D

"""
--- Setup Methods
"""
func _ready() -> void:
	SettingsController.connect("retranslate",retranslate_description)

"""
--- Runtime Methods
"""
func _unhandled_input(event: InputEvent) -> void:
	if active and event.is_action_pressed("delete_board_element"):
		GameController.release_focus()
		Signals.emit_signal('delete_board_line',self)

func _process(delta: float) -> void:
	if not element0 and Global.board_elements.has(element0Name):
		set_element(0,Global.board_elements[element0Name])
	if not element1 and Global.board_elements.has(element1Name):
		set_element(1,Global.board_elements[element1Name])

func _physics_process(delta: float) -> void:
	if is_instance_valid(element0) and is_instance_valid(element1):
		position = (element0.position).lerp(element1.position, 0.5); 
	elif is_instance_valid(element0):
		position = element0.position
	
	if element0 and element1:
		connectionLine.set_point_position(1,self.position-element0.position-Global.BOARD_LINE_OFFSET)
		connectionLine.set_point_position(0,self.position-element1.position-Global.BOARD_LINE_OFFSET)
	elif element0:
		connectionLine.set_point_position(0,self.position-element0.position-Global.BOARD_LINE_OFFSET)
		connectionLine.set_point_position(1,self.get_local_mouse_position())

"""
--- General Methods
"""

func set_element(idx:int,element:Control) -> void:
	match idx:
		0:
			element0 = element
			element0Name = element.elementName 
		1:
			element1 = element
			element1Name = element.elementName
			connectionLabel.visible = true
	connectionLine.gradient.colors[idx] = element.elementColor

func toggle_description() -> void:
	connectionLabel.visible = not connectionLabel.visible

func set_description(text) -> void:
	description = text
	connectionLabel.text = tr(description)

func retranslate_description() -> void:
	connectionLabel.text = tr(description)

"""
--- Input Signal Methods
"""
func _on_mouse_entered() -> void:
	Signals.emit_signal("input_help_set",GameController.get_input_key_list("delete_board_element"),"REMOVE_BOARD_LINE_INPUT_HELP")
	active = true

func _on_mouse_exited() -> void:
	Signals.emit_signal("input_help_delete","REMOVE_BOARD_LINE_INPUT_HELP")
	active = false

func saving() -> Dictionary:
	var output: Dictionary = {
		"node": "res://scenes/UI/board/board_elements/connection_base.tscn",
		"nodepath": get_path(),
		"parent": get_parent().get_path(),
		"name": name,
		"lineName": lineName,
		"posX": position.x,
		"posY": position.y,
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
	element0Name = input["element0"]
	element1Name = input["element1"]
	if Global.board_elements.has_all([element0Name,element1Name]):
		set_element(0,Global.board_elements[element0Name])
		set_element(1,Global.board_elements[element1Name])
	return true
