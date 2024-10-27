extends CanvasLayer

const SPEED = 3


var dragged = false
var drawing = false

var mouse_offset

var line_element_instance
var board_element_instance

var board_element_0 = null
var board_element_1 = null

var array_board_elements = []
var array_line_elements = []

# Line ELements preloaded for instantiation
var line_element = preload("res://scenes/UI/board_elements/line_element_base.tscn")

# Board ELements preloaded for instantiation
var board_element = preload("res://scenes/UI/board_elements/board_element_base.tscn")
var note_element = preload("res://scenes/UI/board_elements/board_element_note.tscn")
var item_element = preload("res://scenes/UI/board_elements/board_element_item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	$Board.position = (DisplayServer.screen_get_size() /2) - Vector2i($Board/TextureRect.size/2)
	
	Signals.connect('delete_line', delete_line_element)
	Signals.connect('delete_element', delete_board_element)
	Signals.connect('create_item_element', create_item)

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("table_toggle"):
		toggle_board()
	
	if event.is_action_pressed("drag_board"):
		dragged = true
		mouse_offset = $Board.position - $Board.get_global_mouse_position()
	elif event.is_action_released("drag_board"):
		dragged = false
	
	if event.is_action_pressed("ui_cancel"):
		end_drawing()
	
	if event.is_action_pressed("create_line"):
		start_drawing()
	
	if event.is_action_released("create_line"):
		end_drawing()

func start_drawing() -> void:
	if Global.Active_Board_Element != null:
		drawing = true
		line_element_instance = line_element.instantiate()
		line_element_instance.drawing = true
		line_element_instance.thickness = 2.0
		line_element_instance.color = Color.LIGHT_BLUE
		line_element_instance.board_element_0 = Global.Active_Board_Element
		$Board.add_child(line_element_instance)
		line_element_instance.position = $Board.get_local_mouse_position()

func end_drawing() -> void:
	if Global.Active_Board_Element == null and drawing:
		line_element_instance.queue_free()
		line_element_instance = null
		drawing = false
	elif Global.Active_Board_Element != null and drawing:
		if Global.Active_Board_Element == line_element_instance.board_element_0:
			line_element_instance.queue_free()
		else:
			line_element_instance.board_element_1 = Global.Active_Board_Element
			line_element_instance.toggle_description()
			array_line_elements.append(line_element_instance)
			line_element_instance.drawing = false
		line_element_instance = null
		drawing = false

func delete_line_element(line) -> void:
	var index = array_line_elements.find(line)
	array_line_elements[index].queue_free()
	array_line_elements.remove_at(index)

func delete_board_element(element) -> void:
	var index = array_board_elements.find(element)
	for line in array_line_elements:
		if line.board_element_0 == element or line.board_element_1 == element:
			delete_line_element(line)
	array_board_elements[index].queue_free()
	array_board_elements.remove_at(index)

func toggle_board() -> void:
	if visible:
		Global.CloseMenu()
	else:
		Global.OpenMenu()
	visible = not visible

func _physics_process(delta: float) -> void:
	"""if Global.InMenu and visible and not dragged:
		var horizontal := Input.get_axis("ui_left", "ui_right")
		var vertical := Input.get_axis("ui_up", "ui_down")
		var direction = Vector2(horizontal*SPEED,vertical*SPEED)
		if horizontal or vertical:
			$Board.position = $Board.position + direction
	el"""
	if Global.InMenu and visible and dragged:
		$Board.position = $Board.get_global_mouse_position() + mouse_offset

func _on_add_note_button_pressed() -> void:
	create_note()
	
func create_element() -> void:
	array_board_elements.append(board_element_instance)
	$Board.add_child(board_element_instance)
	board_element_instance.position = Vector2($Board/TextureRect.size/2)
	board_element_instance = null
	
func create_note() -> void:
	board_element_instance = note_element.instantiate()
	create_element()
	
func create_item(_texture, _label, _text) -> void:
	print("test")
	board_element_instance = item_element.instantiate()
	board_element_instance.texture = _texture
	board_element_instance.label = _label
	board_element_instance.text = _text
	create_element()
	
