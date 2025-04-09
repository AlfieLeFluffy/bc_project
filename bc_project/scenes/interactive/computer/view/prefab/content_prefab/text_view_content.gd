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
		Signals.s_CreateBoardElement.emit(ElementResource.new().setup(ElementResource.elementType.FILE,arguments["name"],computer.interactableResource.timeline,arguments["text"],null))
		Signals.s_InputHelpFree.emit("INTERACT_INPUT_HELP")
#endregion


#region Signal Methods
func _on_mouse_entered() -> void:
	Signals.s_InputHelpSet.emit(GameController.get_input_key_list("add_to_board"),"ADD_TO_BOARD_INPUT_HELP")


func _on_mouse_exited() -> void:
	Signals.s_InputHelpFree.emit("INTERACT_INPUT_HELP")
#endregion
