class_name InputHelpLabel extends RichTextLabel

"""
--- Setup Methods
"""
@export_range(1.0,10.0,0.1) var fadeTimeout: float = 3.0
@export_range(1.0,10.0,0.1) var activeTimeout: float = 1.0

#region Variables
var input:Array
var description:String

var active: bool = false
var highlight: bool = false
#endregion



"""
--- Setup Methods
"""
#region Setup Methods
func _ready() -> void:
	SettingsController.s_Retranslate.connect(retranslate_label)
	fade.call_deferred()

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
	var inputDuplicate: Array[String] = input.duplicate()
	if inputDuplicate.size() == 1:
		keys = inputDuplicate.pop_front()
	else:
		keys = inputDuplicate.pop_front()
		for key in inputDuplicate:
			keys = keys + " / " + key
	text = "[font_size=20][right][color=#%s]%s[/color] [color=#%s] - %s[/color]" % [Global.color_TextHighlight.to_html(),keys,Global.color_TextBright.to_html(),tr(description)]
#endregion



#region Input Methods
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("highlight"):
		highlight = true
		visible = true
		active_timer()
		GameController.fade_to_color(self, Color.WHITE)
	if event.is_action_released("highlight"):
		highlight = false
#endregion



#region Visibility Methods
func active_timer() -> void:
	await get_tree().create_timer(activeTimeout).timeout
	if highlight:
		active_timer.call_deferred()
		return
	fade.call_deferred()

func fade() -> void:
	await get_tree().create_timer(fadeTimeout).timeout
	if highlight:
		return
		
	await GameController.fade_to_color(self, Color.TRANSPARENT)
	visible = false
#endregion



#region Signal Methods
func retranslate_label() -> void:
	setup_label()
#endregion
