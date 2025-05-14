class_name Interactable extends Node2D


"""
--- Runtime Variables
"""
#region Runtime Variables
var active: bool = false
var mouseHover: bool = false
var inRadius: bool = false
var highlight: bool = false
#endregion



#region Resource
@export var interactableResource: InteractableResource
#endregion



"""
--- Setup functions
"""
#region Setup Methods
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_timeline_info()
	setup_interactable_info()
	_local_ready()
	if not SettingsController.s_Retranslate.is_connected(setup_interactable_info):
		SettingsController.s_Retranslate.connect(setup_interactable_info)
	#%Label.position.x = global_position.x - %Label.position.x /4
	#%Label.position.y = %Sprite2D.global_position.y - (%Sprite2D.texture.get_size().y / 2) - 10

func setup_interactable_info() -> void:
	if interactableResource:
		%Label.text = "[font_size=%s][color=#%s]%s" % [str(SettingsController.scale_font_size(28)),Global.color_TextHighlight.to_html(),tr(interactableResource.item_name)]

func setup_timeline_info() -> void:
	var parent:Node = get_parent()
	while parent != null:
		if parent is Timeline:
			if interactableResource:
				interactableResource.timeline = parent.resource.name
			return
		parent = parent.get_parent()
	
	interactableResource.timeline = "null"

# Local ready function for instantiated objects
func _local_ready() -> void:
	pass
#endregion



"""
--- Runtime functions
"""
#region Process Methods
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mouseHover and inRadius:
		active = true
	else:
		active = false
	_local_process(delta)

# Active function if no dialog detected
func _local_process(delta: float) -> void:
	pass
#endregion



#region Input Methods
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("highlight"):
		highlight = true
		if not mouseHover:
			activate_hover()
	if event.is_action_released("highlight") or not Input.is_action_pressed("highlight"):
		highlight = false
		if not mouseHover:
			deactivate_hover()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and active:
		if check_line_of_sight() or interactableResource.ignore_line_of_sight:
			if interactableResource.callables:
				for callable in interactableResource.callables:
					callable.run(self)
			_interact_function(event)
	elif event.is_action_pressed("add_to_board") and active and interactableResource.detective_board_toggle:
		if check_line_of_sight() or interactableResource.ignore_line_of_sight:
			add_board_element(event)

func check_line_of_sight() -> bool:
	var raycast: RayCast2D = RayCast2D.new()
	var player: Player = get_tree().get_first_node_in_group("Player")
	if not player:
		raycast.queue_free()
		return false
	raycast.target_position = to_local(player.position)
	raycast.set_collision_mask_value(5,true)
	raycast.set_collision_mask_value(9,true)
	add_child(raycast)
	raycast.force_raycast_update()
	if raycast.is_colliding():
		if raycast.get_collider() is Player:
			raycast.queue_free()
			return true
	raycast.queue_free()
	return false

# Active function if no dialog detected
func _interact_function(event: InputEvent) -> void:
	pass
	
func hide_object() -> void:
	await GameController.fade_to_color(self,Color.TRANSPARENT,0.5)
	visible = false

func show_object() -> void:
	await GameController.fade_to_color(self,Color.WHITE,0.5)
	visible = false

func move_to_position(endPosition: Vector2 = Vector2(0.0,0.0), time: float = 1.5) -> void:
	if endPosition == Vector2(0.0,0.0):
		return
	var tween: Tween = create_tween()
	tween.tween_property(self,"position", endPosition, time)
#endregion



#region Global Call Methods
# Active function if no dialog detected
func add_board_element(event: InputEvent) -> void:
	Signals.s_CreateBoardElement.emit(ElementResource.new().setup(ElementResource.elementType.OBJECT,interactableResource.item_name,interactableResource.timeline,interactableResource.description,get_sprite_from_current_frame()))
#endregion



#region Image Manipulation Methods
# Returns current sprite from interactable item's sprite sheet
func get_sprite_from_current_frame() -> Texture2D:
	if %Sprite2D.texture:
		var texture = %Sprite2D.texture
		if %Sprite2D.hframes > 1 or %Sprite2D.vframes > 1: 
			var atlas = AtlasTexture.new()
			atlas.atlas = texture
			var frameSize = Vector2(%Sprite2D.texture.get_width() / %Sprite2D.hframes,%Sprite2D.texture.get_height() / $Sprite2D.vframes)
			atlas.region = Rect2(frameSize * Vector2(%Sprite2D.frame_coords), frameSize)
			texture = atlas
		return texture
		
	#if $AnimatedSprite2D.sprite_frames:
	#	var currentSprite: Texture2D = $AnimatedSprite2D.get_sprite_frames().get_frame_texture($AnimatedSprite2D.animation, $AnimatedSprite2D.get_frame())
	#	return currentSprite
		
	return load("res://textures/icon.svg")
#endregion



#region Interactivity Methods
func activate_hover() -> void:
	if interactableResource:
		if interactableResource.show_outline:
			material.set("shader_parameter/line_thickness",1)

func deactivate_hover() -> void:
	if interactableResource:
		if interactableResource.show_outline:
			material.set("shader_parameter/line_thickness",0)

func activate_interactivity() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	if interactableResource:
		if interactableResource.show_labels:
			%Label.visible = true
	Global.Active_Interactive_Item = self
	if interactableResource:
		if interactableResource.detective_board_toggle:
			Signals.s_InputHelpSet.emit(GameController.get_input_key_list("add_to_board"),"ADD_TO_BOARD_INPUT_HELP")
	Signals.s_InputHelpSet.emit(GameController.get_input_key_list("interact"),"INTERACT_INPUT_HELP")

func deactivate_interactivity() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	if interactableResource:
		if interactableResource.show_labels:
			%Label.visible = false
	Global.Active_Interactive_Item = null
	if interactableResource:
		if interactableResource.detective_board_toggle:
			Signals.s_InputHelpFree.emit("ADD_TO_BOARD_INPUT_HELP")
	Signals.s_InputHelpFree.emit("INTERACT_INPUT_HELP")
#endregion



#region Persistence Methods
func saving() -> Dictionary:
	var output: Dictionary = {
		"persistent": true,
		"nodepath": get_path(),
		"parent": get_parent().get_path(),
		"visible": visible,
		"position_x": position.x,
		"position_y": position.y,
	}
	return output

func loading(input: Dictionary) -> bool:
	if input.has_all(["visible", "position_x", "position_y"]):
		visible = input["visible"]
		position.x = input["position_x"]
		position.y = input["position_y"]
	return true
#endregion
