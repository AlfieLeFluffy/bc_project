extends CanvasLayer

"""
--- Runtime Variables
"""
var mouse_offset: Vector2
@onready var screenSize: Vector2 = DisplayServer.screen_get_size()
@onready var boardControler: Control = $BoardControler
@onready var boardBackground: TextureRect = boardControler.get_node("BoardBackground")

"""
--- Setup Methods
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	setup_board()
	Signals.emit_signal("input_help_set",GameController.get_input_key_list("detective_board_toggle"), "DETECTIVE_BOARD_INPUT_HELP")

func setup_board() -> void:
	boardBackground.size = screenSize*2
	boardControler.position = screenSize/2 - boardBackground.size/2

"""
--- Runtime Methods
"""
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("detective_board_toggle") or visible and event.is_action_pressed("ui_menu"):
		toggle_board()
		GameController.release_focus()
		get_viewport().set_input_as_handled()
"""
--- General Methods
"""
func toggle_board() -> void:
	visible = not visible
