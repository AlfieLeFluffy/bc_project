extends Node2D


var active: bool = false
var mouseHover: bool = false
var inRadius: bool = false

"""
--- Exported Variables
"""

@export_group("Interactable Resource")
@export var interactable_resource: InteractableResource
@export var dialog_resource: DialogResource

"""
--- Setup functions
"""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interactable_info_setup()
	local_ready()

func interactable_info_setup() -> void:
	if interactable_resource:
		$Labels/Label.text = interactable_resource.item_name
		name = interactable_resource.item_name

# Local ready function for instantiated objects
func local_ready() -> void:
	pass
	

"""
--- Runtime functions
"""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mouseHover and inRadius:
		active = true
	else:
		active = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and active:
		if dialog_resource:
			DialogScripts.start_dialog(dialog_resource.dialog,dialog_resource.titleName)
			Signals.setup_conversation_profile.emit("right", interactable_resource.item_name, get_sprite_from_current_frame())
		else:
			interact_function(event)
	elif event.is_action_pressed("add_to_board") and active:
		Signals.emit_signal('create_item_element',get_sprite_from_current_frame(), interactable_resource.item_name,interactable_resource.description)
		AudioManager.play_sound("ding")

"""
--- Custom functions
"""

# Active function if no dialog detected
func interact_function(event: InputEvent) -> void:
	pass

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
	$Labels.visible = true
	Global.Active_Interactive_Item = self
	Signals.emit_signal("help_text_toggle",Global.help_signal_type.INTERACTIVE,true)

func deactivate_interactivity() -> void:
	$Labels.visible = false
	Global.Active_Interactive_Item = null
	Signals.emit_signal("help_text_toggle",Global.help_signal_type.INTERACTIVE,false)
