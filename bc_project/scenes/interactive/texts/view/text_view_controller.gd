extends CanvasLayer

"""
--- Runtime Variables
"""
signal create_board_element_text()

@onready var textLabel: Label = $Control/TextName
@onready var textContentsLabel: RichTextLabel = $Control/TextContents

var type: TextObjectResourse.textTypeEnum
var textName: String
var textContent: String

"""
--- Setup Methods
"""
func _ready() -> void:
	Signals.s_InputHelpSet.emit(GameController.get_input_key_list("add_to_board"),"ADD_TO_BOARD_INPUT_HELP")

func setup_text_view(textResource: TextObjectResourse) -> void:
	type = textResource.textType
	textName = textResource.textName
	textContent = textResource.textContents
	
	textLabel.text = tr(textName)
	textContentsLabel.text = tr(textContent)

"""
--- Runtime Methdos
"""
func _unhandled_input(event: InputEvent) -> void:
	if visible and (event.is_action_pressed("ui_menu") or event.is_action_pressed("detective_board_toggle")):
		exit_view()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("add_to_board"):
		emit_signal("create_board_element_text", null)
		exit_view()

func exit_view() ->void:
	Signals.s_InputHelpFree.emit("ADD_TO_BOARD_INPUT_HELP")
	queue_free()

"""
--- Signal Methods
"""
func _on_back_button_pressed() -> void:
	exit_view()

func _on_background_button_pressed() -> void:
	exit_view()
