extends Node


var drawing = false

var line_element_instance

var board_element_0 = null
var board_element_1 = null

# Line ELements preloaded for instantiation
var line_element = preload("res://scenes/UI/board/board_elements/line_element_base.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.connect('delete_line', delete_line_element)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and drawing:
		end_drawing()
	
	if event.is_action_pressed("create_line"):
		if not drawing:
			start_drawing()
	
	if event.is_action_released("create_line"):
		end_drawing()

func start_drawing() -> void:
	if Global.Active_Board_Element != null:
		drawing = true
		line_element_instance = line_element.instantiate()
		line_element_instance.drawing = true
		line_element_instance.thickness = 2.0
		line_element_instance.color = Color.LIGHT_BLUE
		line_element_instance.board_element_0 = Global.Active_Board_Element
		get_parent().add_child(line_element_instance)
		line_element_instance.position = get_parent().get_local_mouse_position()

func end_drawing() -> void:
	if Global.Active_Board_Element == null and drawing:
		line_element_instance.queue_free()
		line_element_instance = null
		drawing = false
	elif Global.Active_Board_Element != null and drawing:
		if Global.Active_Board_Element == line_element_instance.board_element_0:
			line_element_instance.queue_free()
		else:
			line_element_instance.board_element_1 = Global.Active_Board_Element
			line_element_instance.toggle_description()
			Global.array_line_elements.append(line_element_instance)
			line_element_instance.drawing = false
		line_element_instance = null
		drawing = false

func delete_line_element(line) -> void:
	var index = Global.array_line_elements.find(line)
	Global.array_line_elements[index].queue_free()
	Global.array_line_elements.remove_at(index)
	Signals.emit_signal("help_text_toggle","deleteElement",0)
