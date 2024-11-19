extends CharacterBody2D

"""
--- Exported Physics Constants
"""

@export_group("Character Body Constants")
@export var SPEED: int = 300.0
@export var JUMP_VELOCITY: int = -400.0

"""
--- Exported Variables
"""

@export_group("NPC Resource")
@export var npc_resource: npcResource

var active: bool = false
var mouseHover: bool = false
var inRadius: bool = false

"""
--- Setup functions
"""

func _ready() -> void:
	npc_info_setup()
	dialog_handler_setup()

func npc_info_setup() -> void:
	name = npc_resource.npcName

func dialog_handler_setup() -> void:
	$DialogHandler.dialogs = npc_resource.dialogs
	$DialogHandler.dialogIndex = npc_resource.dialogIndex
	$DialogHandler.titles = npc_resource.titles
	$DialogHandler.titleIndex = npc_resource.titleIndex

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
