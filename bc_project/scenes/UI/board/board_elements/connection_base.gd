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
		Signals.s_DeleteBoardConnection.emit(self)

func _process(delta: float) -> void:
	if not resource.start and Global.board_elements.has(resource.startId):
		set_element(0,Global.board_elements[resource.startId])
	if not resource.end and Global.board_elements.has(resource.endId):
		set_element(1,Global.board_elements[resource.endId])

func _physics_process(delta: float) -> void:
	position = resource.start.position
	if resource.start and resource.end:
		var endPosition = resource.end.position - self.position + get_edge_position_element_to_element(resource.end,resource.start)
		var startPosition = resource.start.position - self.position + get_edge_position_element_to_element(resource.start,resource.end)
		
		%ConnectionLabel.position = startPosition.lerp(endPosition, 0.5) - %ConnectionLabel.size/2
		%Line.set_point_position(1,startPosition)
		%Line.set_point_position(0,endPosition)
		
	elif resource.start:
		%Line.set_point_position(0, resource.start.size / 2)
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
			%ConnectionLabel.visible = true
	%Line.gradient.colors[idx] = Global.color_TextHighlight.lerp(element.resource.color,0.3)

func toggle_description() -> void:
	%ConnectionLabel.visible = not %ConnectionLabel.visible

func set_description(text) -> void:
	resource.description = text
	%Label.text = tr(resource.description)

func retranslate_description() -> void:
	%Label.text = tr(resource.description)

func get_edge_position_element_to_element(start: ElementBase, end: ElementBase) -> Vector2:
	var output: Vector2 = Vector2(0,0)
	var vector: Vector2 = (end.position + (end.size / 2)) - (start.position + (start.size / 2))
	output.x = (vector.x + (start.size.x / 2))
	output.y = (vector.y + (start.size.y / 2))
	return output
#endregion

#region Signal Methods
func _on_mouse_entered() -> void:
	Signals.s_InputHelpSet.emit(GameController.get_input_key_list("delete_board_element"),"REMOVE_BOARD_LINE_INPUT_HELP")
	active = true

func _on_mouse_exited() -> void:
	Signals.s_InputHelpFree.emit("REMOVE_BOARD_LINE_INPUT_HELP")
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
		"resources" : {
			"resource": resource,
		}
	}
	return output

func loading(input: Dictionary) -> bool:
	position.x = input["posX"]
	position.y = input["posY"]
	if input.has("resources"):
		if input["resources"].has("resource"):
			resource = input["resources"]["resource"]
	
	name = resource.id
	
	if Global.board_elements.has_all([resource.startId,resource.endId]):
		set_element(0,Global.board_elements[resource.startId])
		set_element(1,Global.board_elements[resource.endId])
	
	Global.line_elements[resource.id] = self
	return true
#endregion
