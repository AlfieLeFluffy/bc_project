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

@export_group("Resources")
@export var npc_resource: npcResource
@export var dialog_resource: DialogResource

var active: bool = false
var mouseHover: bool = false
var inRadius: bool = false

"""
--- Setup functions
"""

func _ready() -> void:
	npc_info_setup()

func npc_info_setup() -> void:
	if npc_resource:
		name = npc_resource.npcName

"""
--- Input functions
"""

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and dialog_resource and active:
		Signals.start_npc_conversation_state.emit(self)
		DialogScripts.start_dialog(dialog_resource.dialog,dialog_resource.titleName)
		Signals.setup_conversation_profile.emit("right", name, get_sprite_from_current_frame())

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
-- Custom functions
"""

# Returns current sprite from interactable item's sprite sheet
func get_sprite_from_current_frame() -> Texture2D:
	var currentSprite: Texture2D = $AnimatedSprite2D.get_sprite_frames().get_frame_texture($AnimatedSprite2D.animation, $AnimatedSprite2D.get_frame())
	return currentSprite

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
