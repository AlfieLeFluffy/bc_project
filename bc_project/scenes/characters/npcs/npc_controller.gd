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
		if npc_resource.spritesheet:
			$Sprite2D.texture = npc_resource.spritesheet
			$Sprite2D.hframes = npc_resource.frameVector.x
			$Sprite2D.vframes = npc_resource.frameVector.y
			$Sprite2D.material = ShaderMaterial.new()
			$Sprite2D.material.shader = load("res://shaders/outline_shader.gdshader")
			$Sprite2D.material.set("shader_parameter/line_thickness",0)
			

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
		$Sprite2D.flip_h = true
	elif velocity.x != 0:
		$Sprite2D.flip_h = false

	move_and_slide()

"""
-- Custom functions
"""

# Returns current sprite from interactable item's sprite sheet
func get_sprite_from_current_frame() -> Texture2D:
	if $Sprite2D.texture:
		var texture = $Sprite2D.texture
		if $Sprite2D.hframes > 1 or $Sprite2D.vframes > 1: 
			var atlas = AtlasTexture.new()
			atlas.atlas = texture
			var frameSize = Vector2($Sprite2D.texture.get_width() / $Sprite2D.hframes,$Sprite2D.texture.get_height() / $Sprite2D.vframes)
			atlas.region = Rect2(frameSize * Vector2($Sprite2D.frame_coords), frameSize)
			texture = atlas
		return texture
		
	#if $AnimatedSprite2D.sprite_frames:
	#	var currentSprite: Texture2D = $AnimatedSprite2D.get_sprite_frames().get_frame_texture($AnimatedSprite2D.animation, $AnimatedSprite2D.get_frame())
	#	return currentSprite
		
	return load("res://textures/icon.svg")

"""
--- Activate/deactivate interactivity
"""

func activate_hover() -> void:
	$Sprite2D.material.set("shader_parameter/line_thickness",1)

func deactivate_hover() -> void:
	$Sprite2D.material.set("shader_parameter/line_thickness",0)

func activate_interactivity() -> void:
	Signals.emit_signal("help_text_toggle",Global.help_signal_type.TALK,true)

func deactivate_interactivity() -> void:
	Signals.emit_signal("help_text_toggle",Global.help_signal_type.TALK,false)

"""
--- Persistence Methods
"""
func saving() -> Dictionary:
	var output: Dictionary = {
		"persistent": true,
		"nodepath": get_path(),
		"parent": get_parent().get_path(),
		"name": name,
		"posX": position.x,
		"posY": position.y,
		"currentState": $StateMachine.currentState.name
	}
	return output

func loading(input: Dictionary) -> bool:
	name = input["name"]
	position.x = input["posX"]
	position.y = input["posY"]
	if $StateMachine.states.has(input["currentState"]):
		$StateMachine.currentState = $StateMachine.states[input["currentState"]]
	return true
