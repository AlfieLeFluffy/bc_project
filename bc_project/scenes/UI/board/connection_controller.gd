class_name ConnectionControler extends Node

"""
--- Scene Preloads
"""
# Line ELements preloaded for instantiation
const line_element = preload("res://scenes/UI/board/board_elements/connection_base.tscn")

"""
--- Runtime Variables
"""
var drawing = false
var color

var instance
var element0 = null
var element1 = null

"""
--- Setup Methods
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	color = $"../../ColorSetterContainer/ColorPicker".get_item_icon(0).gradient.colors[0]
	Signals.connect('delete_line', delete_line_element)

"""
--- Runtime Methods
"""
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("create_line") and Global.activeElement != null and not drawing:
		Global.release_focus()
		if not drawing:
			start_drawing()
	
	if event.is_action_pressed("ui_cancel") and drawing:
		end_drawing()
		
	if event.is_action_released("create_line") and drawing:
		end_drawing()

"""
--- Drawing Methods
"""
func start_drawing() -> void:
	drawing = true
	instance = line_element.instantiate()
	instance.drawing = true
	instance.thickness = 2.0
	instance.color = color
	instance.element0 = Global.activeElement
	get_parent().add_child(instance)
	instance.position = get_parent().get_local_mouse_position()

func end_drawing() -> void:
	if Global.activeElement == null:
		line_queue_free()
	elif Global.activeElement != null:
		if Global.activeElement == instance.element0:
			line_queue_free()
		else:
			instance.element1 = Global.activeElement
			instance.toggle_description()
			var line = instance
			var line_name = line.element0.elementName + line.element1.elementName
			instance.lineName = line_name
			Global.line_elements[line_name] = instance
			instance.drawing = false
			reset_state()

func line_queue_free() -> void:
	instance.queue_free()
	reset_state()

func reset_state() -> void:
	instance = null
	drawing = false

"""
--- Connection Managment Methods
"""
func delete_line_element(line) -> void:
	Global.line_elements.erase(line.lineName)
	line.queue_free()
	Signals.emit_signal("help_text_toggle",Global.help_signal_type.DELETEELEMENT,false)

"""
--- Input Signal Methods
"""
func _on_color_picker_item_selected(index: int) -> void:
	color = $"../../ColorSetterContainer/ColorPicker".get_item_icon(index).gradient.colors[0]
