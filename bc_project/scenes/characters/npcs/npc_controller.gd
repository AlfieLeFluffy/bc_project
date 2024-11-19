extends CharacterBody2D

"""
--- Exported Physics Constants
"""

@export_group("Character Body Constants")
@export var SPEED: int = 300.0
@export var JUMP_VELOCITY: int = -400.0

"""
--- States Machine Variables
"""

"""
--- Exported Variables
"""

@export_group("Npc Information")
@export var npcName: String

@export_group("Interactive Flags")
@export var active: bool = false
@export var mouseHover: bool = false
@export var inRadius: bool = false

@export_group("Dialog")
@export var dialogIndex: int = 0 
@export var dialogs: Array[DialogueResource]
@export var titleIndex: int = 0 
@export var titles: PackedStringArray

@export_group("State Machine")

"""
--- Input functions
"""

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and active:
		Signals.start_npc_conversation_state.emit(self)
		$DialogHandler.dialog_start()

"""
--- Runtime functions
"""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mouseHover and inRadius:
		active = true
	else:
		active = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x != 0:
		$AnimatedSprite2D.flip_h = false

	move_and_slide()

"""
--- Activate/deactivate interactivity
"""

func activate_hover() -> void:
	pass

func deactivate_hover() -> void:
	pass

func activate_interactivity() -> void:
	Signals.emit_signal("help_text_toggle",Global.help_signal_type.TALK,true)

func deactivate_interactivity() -> void:
	Signals.emit_signal("help_text_toggle",Global.help_signal_type.TALK,false)
