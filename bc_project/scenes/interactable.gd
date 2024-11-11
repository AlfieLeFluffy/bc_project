extends Node2D

enum type_enum {interactable, noninteractable}

@export_category("item information")
@export var item_name: String
@export var timeline: String
@export var type: type_enum
@export var description: String


@export_category("interactive flags")
@export var active: bool = false
@export var mouseHover: bool = false
@export var inRadius: bool = false

@export_category("dialog")
@export var dialogIndex: int = 0 
@export var dialogs: PackedStringArray
@export var headIndex: int = 0 
@export var heads: PackedStringArray

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
	if $Labels.visible == true and inRadius:
		active = true
	else:
		active = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and dialogs.size() != 0 and active:
		DialogueManager.show_example_dialogue_balloon(load(dialogs[dialogIndex]),heads[headIndex])
		return
	if event.is_action_pressed("add_to_board") and active:
		Signals.emit_signal('create_item_element',get_sprite_from_current_frame(), get_meta("Name"),get_meta("Description"))

"""
--- Custom functions
"""

# Returns current sprite from interactable item's sprite sheet
func get_sprite_from_current_frame() -> Texture2D:
	var currentSprite: Texture2D = $AnimatedSprite2D.get_sprite_frames().get_frame_texture($AnimatedSprite2D.animation, $AnimatedSprite2D.get_frame())
	return currentSprite

"""
--- Dialog control functions
"""

func increment_dialog_index(overflowFlag:bool = false) -> void:
	if dialogIndex + 1 >= dialogs.size() and not overflowFlag:
		dialogIndex = 0
	else:
		dialogIndex = dialogIndex + 1

func set_dialog_index(index:int) -> void:
	dialogIndex = index

func append_dialog_file(filepath:String) -> void:
	dialogs.append(filepath)

func increment_head_index(overflowFlag:bool = false) -> void:
	if headIndex + 1 >= heads.size() and not overflowFlag:
		headIndex = 0
	else:
		headIndex = headIndex + 1

func set_head_index(index:int) -> void:
	headIndex = index

func append_head_name(headName:String) -> void:
	heads.append(headName)

"""
--- Area and mouse entry and leave functions
"""

func _on_mouse_entered() -> void:
	$AnimatedSprite2D.material.set("shader_parameter/line_thickness",1)
	mouseHover = true
	if inRadius:
		$Labels.visible = true
		Global.Active_Interactive_Item = self
		Signals.emit_signal("help_text_toggle","interactive",1)


func _on_mouse_exited() -> void:
	$AnimatedSprite2D.material.set("shader_parameter/line_thickness",0)
	mouseHover = false
	if inRadius:
		$Labels.visible = false
		Global.Active_Interactive_Item = null
		Signals.emit_signal("help_text_toggle","interactive",0)


func _on_area_entered(area: Area2D) -> void:
	if area.name == Global.interactive_radius_name:
		if mouseHover:
			$Labels.visible = true
			Global.Active_Interactive_Item = self
			Signals.emit_signal("help_text_toggle","interactive",1)
		inRadius = true

func _on_area_exited(area: Area2D) -> void:
	if area.name == Global.interactive_radius_name:
		if mouseHover:
			$Labels.visible = false
			Global.Active_Interactive_Item = null
			Signals.emit_signal("help_text_toggle","interactive",0)
		inRadius = false
