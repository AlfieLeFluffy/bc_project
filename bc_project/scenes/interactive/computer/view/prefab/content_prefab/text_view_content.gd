class_name TextViewContent extends ApplicationContent

#region Setup Methods
"""
--- Setup Methods
"""
func _setup_arguments() -> void:
	if arguments.has("text"): 
		%TextView.text = arguments["text"] 
#endregion
