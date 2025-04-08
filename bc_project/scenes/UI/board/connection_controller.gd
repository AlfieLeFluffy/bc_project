class_name ConnectionControler extends Node

#region Constants

const preloadLineElement = preload("res://scenes/UI/board/board_elements/connection_base.tscn")
#endregion

#region Varibles
var drawing: bool = false

var activeElement: ElementBase
var instance: ConnectionBase

var clues: Dictionary
#endregion

#region Setup Methods
func _ready() -> void:
	
	import_clues()
	
	Signals.connect("set_active_element",set_active_element)
	Signals.connect('delete_board_line', delete_line_element)

func set_active_element(element:Control) -> void:
	activeElement = element

func import_clues() -> void:
#endregion
	var resource
	for child in get_tree().root.get_children():
		if child is LevelController:
			resource = child.clues
			break
	
	if not resource:
		printerr("This level does not contain clue combinations.")
		return
	
	#if resource.case != Global.Case:
	#	printerr("The global case and case clues dont match. Clue loading stopped.")
	#	return
	
	for clue in resource.clues:
		clues[clue.combination] = clue

#region Runtime Methods
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("create_line") and activeElement != null and not drawing:
		GameController.release_focus()
		if not drawing:
			start_drawing()
		else:
			end_drawing()
	
	if (event.is_action_pressed("ui_cancel") or event.is_action_released("create_line")) and drawing:
		end_drawing()
#endregion

#region Drawing Methods
func start_drawing() -> void:
	drawing = true
	instance = preloadLineElement.instantiate()
	get_parent().add_child(instance)
	instance.set_element(0,activeElement)

func end_drawing() -> void:
	if activeElement == null:
		instance.queue_free()
	elif activeElement == instance.resource.start:
		instance.queue_free()
	elif activeElement != null:
		instance.set_element(1,activeElement)
		instance.resource.id = combine_strings(instance.resource.start.resource.id, instance.resource.end.resource.id)
		instance.name = instance.resource.id
		instance.resource.name = instance.resource.id
		if Global.line_elements.has(instance.resource.id):
			instance.queue_free()
		else:
			Global.line_elements[instance.resource.id] = instance
			var clue: ClueResource = check_for_clue(instance.resource.id)
			if clue != null:
				instance.set_description(clue.label)
				for callable in clue.callables:
					callable.run(self)
				AudioManager.play_sound("sfx/ding")
	drawing = false

func check_for_clue(combination:String) -> ClueResource:
	if clues.has(combination):
		return clues[combination]
	return null
#endregion

#region Connection Managment Methods
func delete_line_element(line) -> void:
	Global.line_elements.erase(line.resource.id)
	line.queue_free()
	Signals.emit_signal("input_help_delete","REMOVE_BOARD_LINE_INPUT_HELP")
#endregion

#region General Methods
func combine_strings(a:String, b:String) -> String:
	if not (a and b):
		printerr("Combining strings can't be done.")
		return ""
	
	if a < b:
		return a+b
	return b+a
#endregion

#region Signal Methods
func _on_color_picker_item_selected(index: int) -> void:
	pass
#endregion
