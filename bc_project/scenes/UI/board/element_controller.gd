class_name ElementControler extends Node

#region Constants
const boardPreload = preload("res://scenes/UI/board/board_elements/element_base.tscn")
const elementPreload = preload("res://scenes/UI/board/board_elements/element_base.tscn")
#endregion

#region Varibles
var instance: ElementBase
#endregion

#region Setup Methods
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.s_CreateBoardElement.connect(create_board_element)
	Signals.s_DeleteBoardElement.connect(delete_board_element)
#endregion

#region Element Management Methods
func create_board_element(elementResource: ElementResource) -> void:
	if check_element(elementResource.name + elementResource.timeline):
		return
	create_element(elementResource)

func create_element(elementResource: ElementResource) -> void:
	instance = elementPreload.instantiate()
	instance.resource = elementResource
	setup_instance(elementResource)
	finalize_element()

func setup_instance(elementResource: ElementResource) -> void:
	Global.board_elements[elementResource.id] = instance
	get_parent().add_child(instance)

func finalize_element() -> void:
	AudioManager.play_sound("sfx/ding")
	var offset = Vector2(randi_range(200,-200),randi_range(200,-200))
	instance.position = Vector2(get_parent().get_node("BoardBackground").size/2+offset)

func delete_board_element(element) -> void:
	for lineKey in Global.line_elements.keys():
		if lineKey.contains(element.resource.id):
			Signals.s_DeleteBoardConnection.emit(Global.line_elements[lineKey])
	Global.board_elements.erase(element.resource.id)
	element.queue_free()
	Signals.s_InputHelpFree.emit("REMOVE_BOARD_ELEMENT_INPUT_HELP")

func check_element(key:String) -> bool:
	print(key)
	if Global.board_elements.has(key):
		AudioManager.play_sound("sfx/deny")
		GameController.play_quick_text_effect_default("ELEMENT_ALREADY_EXISTS")
		return true
	return false
#endregion

#region Signal Methods
func _on_button_symbol_plus_pressed() -> void:
	create_element(ElementResource.new().setup(ElementResource.elementType.NOTE,"note",Global.currentTimeline.resource.name,"",null))
#endregion
