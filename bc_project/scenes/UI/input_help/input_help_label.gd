extends RichTextLabel

func set_label(input:Array, description:String):
	if not input or not description:
		printerr("An error during input help label creation, either input or description are null")
		return
	if input.is_empty():
		printerr("An error during input help label creation, no input key in input array")
		return
	
	name = description
	if input.size() == 1:
		text = "[right][color=lightblue]"+input[0]+"[/color] - "+ tr(description)
		return
	
	var keys: String = input.pop_front()
	for key in input:
		keys = keys + " / " + key
	text = "[right][color=lightblue]"+keys+"[/color] - "+ tr(description)
