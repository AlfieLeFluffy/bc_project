class_name DialogueLineExtraction extends Node

@export var label: RichTextLabel
var currentLine: DialogueLine

func _ready() -> void:
	setup_label()
	SettingsController.s_Retranslate.connect(setup_label)
	DialogueManager.got_dialogue.connect(set_current_line)

func setup_label() -> void:
	if not label:
		printerr("Error: Dialogue Extraction, no label available.")
		return
	
	var key: String = GameController.get_input_key("add_to_board")
	label.text = "[font_size=%s][right][color=#%s]%s[/color] [color=#%s] - %s[/color]" % [str(SettingsController.scale_font_size(32)), Global.color_TextHighlight.to_html(),key,Global.color_TextBright.to_html(),tr("ADD_TO_BOARD_INPUT_HELP")]

func set_current_line(line: DialogueLine) -> void:
	if line.get_tag_value("board"):
		currentLine = line
	else:
		currentLine = null
	update_label()

func _input(event: InputEvent) -> void:
	if not currentLine:
		return
	if not currentLine.get_tag_value("board"):
		return
	if event.is_action_pressed("add_to_board") and currentLine:
		var elementResource: ElementResource = ElementResource.new()
		var elementName: String = currentLine.get_tag_value("board")
		elementResource.setup(ElementResource.elementType.DIALOGUE,elementName,Global.currentTimeline.resource.name,currentLine.text,null)
		Signals.s_CreateBoardElement.emit(elementResource)

func update_label() -> void:
	if not label:
		printerr("Error: Dialogue Extraction, no label available.")
		return
	
	if currentLine:
		label.visible = true
	else:
		label.visible = false
