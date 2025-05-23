class_name DetectiveBoardMenu extends Control

#region Variables
var mouse_offset: Vector2
@onready var screenSize: Vector2 = get_viewport().size
#endregion

#region Setup Methods
func _ready() -> void:
	visible = false
	setup_board()
	Signals.s_InputHelpSet.emit(GameController.get_input_key_list("detective_board_toggle"), "DETECTIVE_BOARD_INPUT_HELP")

func setup_board() -> void:
	%DetectiveBoardLabelText.text = "[font_size=32]%s" % [tr("DETECTIVE_BOARD_LABEL")]
	%BoardBackground.size = screenSize*2
	%BoardControler.position = screenSize/2 - %BoardBackground.size/2
#endregion



#region Runtime Methods
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("detective_board_toggle") or visible and event.is_action_pressed("ui_menu"):
		toggle_board()
		GameController.release_focus()
	if visible:
		get_viewport().set_input_as_handled()

func toggle_board() -> void:
	visible = not visible
#endregion



#region Signal Methods
func _on_create_note_button_pressed() -> void:
	var noteResource: ElementResource = ElementResource.new()
	var noteName: String = str(randi_range(0,99999999))
	while Global.board_elements.has(noteName):
		noteName = str(randi_range(0,99999999))
	noteResource.setup(ElementResource.elementType.NOTE,noteName,"000","")
	Signals.s_CreateBoardElement.emit(noteResource)
#endregion
