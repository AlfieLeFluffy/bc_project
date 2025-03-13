class_name Interactable extends Node2D


"""
--- Runtime Variables
"""
var active: bool = false
var mouseHover: bool = false
var inRadius: bool = false

@onready var label: Label = $Labels/Label
@onready var sprite: Sprite2D = $Sprite2D

"""
--- Exported Variables
"""

@export var interactable_resource: InteractableResource
@export var dialog_resource: DialogueResource

"""
--- Setup functions
"""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_timeline_info()
	setup_interactable_info()
	local_ready()

func setup_interactable_info() -> void:
	if interactable_resource:
		name = interactable_resource.item_name
		label.text = tr(interactable_resource.item_name)

func setup_timeline_info() -> void:
	var parent:Node = get_parent()
	while parent != null:
		if parent is TimelineState:
			break
		parent = parent.get_parent()
	if parent == null:
		interactable_resource.timeline = "null"
	elif parent is TimelineState:
		interactable_resource.timeline = parent.name

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
	local_process(delta)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and active:
		if dialog_resource:
			interact_conversation(event)
		else:
			interact_function(event)
	elif event.is_action_pressed("add_to_board") and active:
		add_board_element(event)

"""
--- Custom functions
"""
# Active function if no dialog detected
func interact_conversation(event: InputEvent) -> void:
	CustomDialogueScripts.start_dialogue(dialog_resource)
	Signals.setup_conversation_profile.emit("right", interactable_resource.item_name, get_sprite_from_current_frame())

# Active function if no dialog detected
func interact_function(event: InputEvent) -> void:
	pass

# Active function if no dialog detected
func local_process(delta: float) -> void:
	pass

# Active function if no dialog detected
func add_board_element(event: InputEvent) -> void:
	Signals.emit_signal('create_board_element',ElementResource.new().setup(ElementResource.elementType.OBJECT,interactable_resource.item_name,interactable_resource.timeline,interactable_resource.description,get_sprite_from_current_frame()))


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
	if interactable_resource.show_labels:
		$Labels.visible = true
	Global.Active_Interactive_Item = self
	Signals.emit_signal("input_help_set",GameController.get_input_key_list("add_to_board"),"ADD_TO_BOARD_INPUT_HELP")
	Signals.emit_signal("input_help_set",GameController.get_input_key_list("interact"),"INTERACT_INPUT_HELP")

func deactivate_interactivity() -> void:
	$Labels.visible = false
	Global.Active_Interactive_Item = null
	Signals.emit_signal("input_help_delete","ADD_TO_BOARD_INPUT_HELP")
	Signals.emit_signal("input_help_delete","INTERACT_INPUT_HELP")
