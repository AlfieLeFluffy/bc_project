class_name ElementBase extends MarginContainer

#region Varibles
var resource: ElementResource

var active = false
var dragged = false
var mouseOffset: Vector2

var content: ElementContentBase

@onready var parent: Node = get_parent()
@onready var boardSize: Vector2 = parent.get_node("BoardBackground").size
#endregion

#region Setup Methods
func _ready() -> void:
	if resource:
		name = resource.id
		%ElementLabel.text = "%s : %s" % [tr(resource.name), resource.timeline]
		%ElementTypeLabel.text = ElementResource.elementType.keys()[resource.type]
		%Texture.modulate = %Texture.modulate.lerp(resource.color,0.2)
		_setup_element()

func _setup_element() -> void:
	content = load(resource.elementContent[resource.type]).instantiate()
	content._setup_content(resource)
	%Stack.add_child(content)
	%Stack.move_child(content,1)
#endregion

#region Runtime Methods
func _gui_input(event: InputEvent) -> void:
	if active and event.is_action_pressed("drag_board_element"):
		mouseOffset = position - get_global_mouse_position()
		dragged = true
	elif event.is_action_released("drag_board_element"):
		dragged = false

func _unhandled_input(event: InputEvent) -> void:
	if active and event.is_action("delete_board_element"):
		delete_element()

func _physics_process(delta: float) -> void:
	if visible and dragged:	
		position = get_global_mouse_position() + mouseOffset
		restrain_element()

func delete_element() -> void:
	GameController.release_focus()
	Signals.emit_signal('delete_board_element',self)
	get_viewport().set_input_as_handled()
#endregion

#region Restrain Methods
func restrain_element() -> void:
	position.x = max(position.x,0)
	position.y = max(position.y,0)
	position.x = min(position.x,boardSize.x - self.size.x)
	position.y = min(position.y,boardSize.y - self.size.y)
#endregion

#region Signal Methods
func _on_delete_button_pressed() -> void:
	delete_element()

func _on_mouse_entered() -> void:
	active = true
	Signals.emit_signal("set_active_element",self)
	Signals.emit_signal("input_help_set",GameController.get_input_key_list("delete_board_element"),"REMOVE_BOARD_ELEMENT_INPUT_HELP")

func _on_mouse_exited() -> void:
	active = false
	Signals.emit_signal("set_active_element",null)
	Signals.emit_signal("input_help_delete","REMOVE_BOARD_ELEMENT_INPUT_HELP")
#endregion

#region Persitence Methods
func saving() -> Dictionary:
	var output: Dictionary = {
		"node":"res://scenes/UI/board/board_elements/element_base.tscn",
		"nodepath": get_path(),
		"parent": get_parent().get_path(),
		"posX": position.x,
		"posY": position.y,
		"resources" : {
			"resource": resource
		}
	}
	return output

func loading(input: Dictionary) -> bool:
	position.x = input["posX"]
	position.y = input["posY"]
	var res: Dictionary = input["resources"]
	if res.has("resource"):
		resource = res["resource"]
	_ready()
	Global.board_elements[resource.id] = self
	return true
#endregion
