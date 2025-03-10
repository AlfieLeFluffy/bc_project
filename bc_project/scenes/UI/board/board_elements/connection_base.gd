class_name ConnectionBase extends Control

#region Varibles
var active = false
var resource: ConnectionResource
#endregion

#region Setup Methods
func _ready() -> void:
	resource = ConnectionResource.new()
	SettingsController.connect("retranslate",retranslate_description)
#endregion

#region Runtime Methods
func _unhandled_input(event: InputEvent) -> void:
	if active and event.is_action_pressed("delete_board_element"):
		GameController.release_focus()
		Signals.emit_signal('delete_board_line',self)

func _process(delta: float) -> void:
	if not resource.start and Global.board_elements.has(resource.startId):
		set_element(0,Global.board_elements[resource.startId])
	if not resource.end and Global.board_elements.has(resource.endId):
		set_element(1,Global.board_elements[resource.endId])

func _physics_process(delta: float) -> void:
	if is_instance_valid(resource.start) and is_instance_valid(resource.end):
		position = (resource.start.position).lerp(resource.end.position, 0.5); 
	elif is_instance_valid(resource.start):
		position = resource.start.position
	
	if resource.start and resource.end:
		%Line.set_point_position(1,self.position-resource.start.position-Global.BOARD_LINE_OFFSET)
		%Line.set_point_position(0,self.position-resource.end.position-Global.BOARD_LINE_OFFSET)
	elif resource.start:
		%Line.set_point_position(0,self.position-resource.start.position-Global.BOARD_LINE_OFFSET)
		%Line.set_point_position(1,self.get_local_mouse_position())
#endregion

#region General Methods
func set_element(idx:int,element:ElementBase) -> void:
	match idx:
		0:
			resource.start = element
			resource.startId = element.resource.id 
		1:
			resource.end = element
			resource.endId = element.resource.id 
			%Label.visible = true
	%Line.gradient.colors[idx] = element.resource.color

func toggle_description() -> void:
	%Label.visible = not %Label.visible

func set_description(text) -> void:
	resource.description = text
	%Label.text = tr(resource.description)

func retranslate_description() -> void:
	%Label.text = tr(resource.description)
#endregion

#region Signal Methods
func _on_mouse_entered() -> void:
	Signals.emit_signal("input_help_set",GameController.get_input_key_list("delete_board_element"),"REMOVE_BOARD_LINE_INPUT_HELP")
	active = true

func _on_mouse_exited() -> void:
	Signals.emit_signal("input_help_delete","REMOVE_BOARD_LINE_INPUT_HELP")
	active = false
#endregion

#region Persitence Methods
func saving() -> Dictionary:
	var output: Dictionary = {
		"node": "res://scenes/UI/board/board_elements/connection_base.tscn",
		"nodepath": get_path(),
		"parent": get_parent().get_path(),
		"posX": position.x,
		"posY": position.y,
		"resource" : {
			"id" : resource.id,
			"description" : resource.description,
			"startId": resource.start.resource.id,
			"endId": resource.end.resource.id,
		}
	}
	return output

func loading(input: Dictionary) -> bool:
	position.x = input["posX"]
	position.y = input["posY"]
	resource = ConnectionResource.new()
	resource.id = input["resource"]["id"]
	resource.description = input["resource"]["description"]
	resource.startId = input["resource"]["startId"]
	resource.endId = input["resource"]["endId"]
	
	name = resource.id
	
	if Global.board_elements.has_all([resource.startId,resource.endId]):
		set_element(0,Global.board_elements[resource.startId])
		set_element(1,Global.board_elements[resource.endId])
	
	Global.line_elements[resource.id] = self
	return true
#endregion
