extends Node2D

enum type_enum {interactable, noninteractable}

@export_group("item information")
@export var item_name: String
@export var timeline: String
@export var type: type_enum
@export var description: String

@export_group("interactive flags")
@export var active: bool = false
@export var mouseHover: bool = false
@export var inRadius: bool = false

@export_group("dialog")
@export var dialogIndex: int = 0 
@export var dialogs: Array[DialogueResource]
@export var titleIndex: int = 0 
@export var titles: PackedStringArray

"""
--- Ready functions
"""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Labels/Label.text = item_name
	LocalReady()

# Local ready function for instantiated objects
func LocalReady() -> void:
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
		if dialogs.size() > 0:
			$DialogHandler.dialog_start()
		elif dialogs.size() <= 0:
			interact_function()
	elif event.is_action_pressed("add_to_board") and active:
		Signals.emit_signal('create_item_element',get_sprite_from_current_frame(), item_name,description)

"""
--- Custom functions
"""

# Active function if no dialog detected
func interact_function() -> void:
	pass

# Returns current sprite from interactable item's sprite sheet
func get_sprite_from_current_frame() -> Texture2D:
	var currentSprite: Texture2D = $AnimatedSprite2D.get_sprite_frames().get_frame_texture($AnimatedSprite2D.animation, $AnimatedSprite2D.get_frame())
	return currentSprite

"""
--- Activate/deactivate interactivity
"""

func activate_hover() -> void:
	$AnimatedSprite2D.material.set("shader_parameter/line_thickness",1)

func deactivate_hover() -> void:
	$AnimatedSprite2D.material.set("shader_parameter/line_thickness",0)

func activate_interactivity() -> void:
	$Labels.visible = true
	Global.Active_Interactive_Item = self
	Signals.emit_signal("help_text_toggle",Global.help_signal_type.interactive,true)

func deactivate_interactivity() -> void:
	$Labels.visible = false
	Global.Active_Interactive_Item = null
	Signals.emit_signal("help_text_toggle",Global.help_signal_type.interactive,false)
