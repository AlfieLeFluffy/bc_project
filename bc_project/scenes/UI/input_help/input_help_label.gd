extends RichTextLabel

"""
--- Setup Methods
"""
var input:Array
var description:String

"""
--- Setup Methods
"""
func _ready() -> void:
	SettingsController.connect("retranslate",retranslate_label)

func set_label(_input:Array, _description:String):
	if not _input or not _description:
		printerr("An error during input help label creation, either input or description are null:"+str(input.size())+" "+description)
		return
	if _input.is_empty():
		printerr("An error during input help label creation, no input key in input array")
		return
	
	name = _description
	description = _description
	input = _input
	setup_label()

func setup_label() -> void:
	var keys: String = ""
	if input.size() == 1:
		keys = input.pop_front()
	else:
		keys = input.pop_front()
		for key in input:
			keys = keys + " / " + key
	text = "[right][color=#%s]%s[/color] [color=#%s] - %s[/color]" % [Global.color_TextHighlight.to_html(),keys,Global.color_TextBright.to_html(),tr(name)]

"""
--- Signal Methods
"""
func retranslate_label() -> void:
	setup_label()
