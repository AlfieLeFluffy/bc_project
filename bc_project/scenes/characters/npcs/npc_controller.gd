class_name NPC extends CharacterBody2D

"""
--- Variables
"""
#region Exported Physics Variables
@export_group("Character Body Constants")
@export var SPEED: int = 300.0
@export var JUMP_VELOCITY: int = -400.0
#endregion

#region Exported Resources
@export_group("Resources")
@export var npcResource: NPCResource
#endregion

#region Variables
var active: bool = false
var mouseHover: bool = false
var inRadius: bool = false
var highlight: bool = false
#endregion

"""
--- Setup functions
"""
#region Setup Methods
func _ready() -> void:
	npc_info_setup()

func npc_info_setup() -> void:
	if npcResource:
		name = npcResource.npcName
		if npcResource.spritesheet:
			$Sprite2D.texture = npcResource.spritesheet
			$Sprite2D.hframes = npcResource.frameVector.x
			$Sprite2D.vframes = npcResource.frameVector.y
			$Sprite2D.material = ShaderMaterial.new()
			$Sprite2D.material.shader = load("res://shaders/outline_shader.gdshader")
			$Sprite2D.material.set("shader_parameter/line_thickness",0)
#endregion



"""
--- Runtime functions
"""
#region Input Methods
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("highlight"):
		highlight = true
		if not mouseHover:
			activate_hover()
	if event.is_action_released("highlight"):
		highlight = false
		if not mouseHover:
			deactivate_hover()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and active:
		for callable in npcResource.callables:
			if callable.methodName == "start_dialogue":
				Signals.start_npc_conversation_state.emit(self)
			callable.run(self)
#endregion



#region Process Methods
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
#endregion



#region Sprite Methods
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
#endregion

"""
--- Activate/deactivate interactivity
"""
#region Interactivity Methods
func activate_hover() -> void:
	$Sprite2D.material.set("shader_parameter/line_thickness",1)

func deactivate_hover() -> void:
	$Sprite2D.material.set("shader_parameter/line_thickness",0)

func activate_interactivity() -> void:
	Signals.emit_signal("input_help_set",GameController.get_input_key_list("interact"),"TALK_INPUT_HELP")

func deactivate_interactivity() -> void:
	Signals.emit_signal("input_help_delete","TALK_INPUT_HELP")
#endregion



"""
--- Persistence Methods
"""
#region Persistence Methods
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
#endregion
