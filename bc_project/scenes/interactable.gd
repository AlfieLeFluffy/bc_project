extends Node2D

var Parent
var Player

var active = false
var mouseHover = false
var inRadius = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$Labels/Label.text = get_meta("Name")
	
	Player = get_tree().get_current_scene().get_node("player")
	
	LocalReady()

# Local ready function for instantiated objects
func LocalReady() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Labels.visible == true and inRadius:
		active = true
	else:
		active = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("add_to_board") and active:
		Signals.emit_signal('create_item_element',get_sprite_from_current_frame(), get_meta("Name"),get_meta("Description"))

func get_sprite_from_current_frame() -> Texture2D:
	var currentSprite: Texture2D = $AnimatedSprite2D.get_sprite_frames().get_frame_texture($AnimatedSprite2D.animation, $AnimatedSprite2D.get_frame())
	return currentSprite
	

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
	if area.name == "interactRadius":
		if mouseHover:
			$Labels.visible = true
			Global.Active_Interactive_Item = self
			Signals.emit_signal("help_text_toggle","interactive",1)
		inRadius = true

func _on_area_exited(area: Area2D) -> void:
	if area.name == "interactRadius":
		if mouseHover:
			$Labels.visible = false
			Global.Active_Interactive_Item = null
			Signals.emit_signal("help_text_toggle","interactive",0)
		inRadius = false
