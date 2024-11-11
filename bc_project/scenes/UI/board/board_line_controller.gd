extends Node


var drawing = false
var color

var line_element_instance

var board_element_0 = null
var board_element_1 = null

# Line ELements preloaded for instantiation
var line_element = preload("res://scenes/UI/board/board_elements/line_element_base.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	color = $"../../ColorSetterContainer/ColorPicker".get_item_icon(0).gradient.colors[0]
	Signals.connect('delete_line', delete_line_element)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("create_line") and Global.Active_Board_Element != null and not drawing:
		Global.release_focus()
		if not drawing:
			start_drawing()
	
	if event.is_action_pressed("ui_cancel") and drawing:
		end_drawing()
		
	if event.is_action_released("create_line") and drawing:
		end_drawing()

func start_drawing() -> void:
	drawing = true
	line_element_instance = line_element.instantiate()
	line_element_instance.drawing = true
	line_element_instance.thickness = 2.0
	line_element_instance.color = color
	line_element_instance.board_element_0 = Global.Active_Board_Element
	get_parent().add_child(line_element_instance)
	line_element_instance.position = get_parent().get_local_mouse_position()

func end_drawing() -> void:
	if Global.Active_Board_Element == null:
		line_queue_free()
	elif Global.Active_Board_Element != null:
		if Global.Active_Board_Element == line_element_instance.board_element_0:
			line_queue_free()
		else:
			line_element_instance.board_element_1 = Global.Active_Board_Element
			line_element_instance.toggle_description()
			Global.array_line_elements.append(line_element_instance)
			line_element_instance.drawing = false
			reset_state()

func line_queue_free() -> void:
	line_element_instance.queue_free()
	reset_state()

func reset_state() -> void:
	line_element_instance = null
	drawing = false

func delete_line_element(line) -> void:
	var index = Global.array_line_elements.find(line)
	Global.array_line_elements[index].queue_free()
	Global.array_line_elements.remove_at(index)
	Signals.emit_signal("help_text_toggle",Global.help_signal_type.deleteElement,false)


func _on_color_picker_item_selected(index: int) -> void:
	color = $"../../ColorSetterContainer/ColorPicker".get_item_icon(index).gradient.colors[0]
