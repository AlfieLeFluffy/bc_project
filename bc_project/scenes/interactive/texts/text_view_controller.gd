extends CanvasLayer

"""
--- Runtime Variables
"""
signal create_board_element()

@onready var textLabel: Label = $Control/TextName
@onready var textContentsLabel: RichTextLabel = $Control/TextContents

var type: TextObjectResourse.textTypeEnum
var textName: String
var textContent: String

"""
--- Setup Methods
"""
func _ready() -> void:
	Signals.emit_signal("input_help_set",GameController.get_input_key_list("add_to_board"),"ADD_TO_BOARD_INPUT_HELP")

func setup_text_view(_textType: TextObjectResourse.textTypeEnum,_textName:String, _textContent:String) -> void:
	type = _textType
	textName = _textName
	textContent = _textContent
	
	textLabel.text = tr(textName)
	textContentsLabel.text = tr(textContent)

"""
--- Runtime Methdos
"""
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_menu"):
		exit_view()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("add_to_board"):
		emit_signal("create_board_element", null)
		exit_view()

func exit_view() ->void:
	Signals.emit_signal("input_help_delete","ADD_TO_BOARD_INPUT_HELP")
	queue_free()

"""
--- Signal Methods
"""
func _on_back_button_pressed() -> void:
	exit_view()
