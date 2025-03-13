class_name TextViewContent extends ApplicationContent

#region Setup Methods
"""
--- Setup Methods
"""
func _setup_arguments() -> void:
	if arguments.has("text"): 
		%TextView.text = arguments["text"] 
#endregion

#region Runtime Methods
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("add_to_board") and arguments.has_all(["name","text"]):
		Signals.emit_signal('create_board_element',ElementResource.new().setup(ElementResource.elementType.FILE,arguments["name"],computer.interactable_resource.timeline,arguments["text"],null))
		Signals.emit_signal("input_help_delete","INTERACT_INPUT_HELP")
#endregion


#region Signal Methods
func _on_mouse_entered() -> void:
	Signals.emit_signal("input_help_set",GameController.get_input_key_list("add_to_board"),"ADD_TO_BOARD_INPUT_HELP")


func _on_mouse_exited() -> void:
	Signals.emit_signal("input_help_delete","INTERACT_INPUT_HELP")
#endregion
