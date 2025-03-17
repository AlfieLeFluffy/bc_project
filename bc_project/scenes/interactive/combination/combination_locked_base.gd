class_name CombinationLockBase extends Interactable

const preloadCombinationLockView = preload("res://scenes/interactive/combination/view/combination_lock_view.tscn")

@export var resource: CombinationLockResource
@export var popupSize: Vector2i = Vector2i(600,300)

var view: CombinationLockView
var popup: PopupMenuController

# Local ready function for instantiated objects
func local_ready() -> void:
	pass

# Active function if no dialog detected
func interact_function(event: InputEvent) -> void:
	if not resource.locked and resource.override:
		_interact_function_unlocked()
	else:
		open_combination_lock_view()

func open_combination_lock_view() -> void:
	if GameController.check_nongameplay_scene():
		return
	if is_instance_valid(popup) and is_instance_valid(view):
		popup.popup.emit()
		return
	create_combination_lock_view()

func create_combination_lock_view() -> void:
	var loadPopupMenu = load("res://scenes/menus/popup_menu_controller.tscn")
	popup = loadPopupMenu.instantiate()
	view = preloadCombinationLockView.instantiate()
	view.base = self
	get_tree().current_scene.add_child(popup)
	popup.setup(view,false,PopupMenuController.popupDirection.UP,popupSize)
	popup.popup.emit()

func _interact_function_unlocked() -> void:
	pass

# Active function if no dialog detected
func local_process(delta: float) -> void:
	pass

# Active function if no dialog detected
func add_board_element(event: InputEvent) -> void:
	Signals.create_board_element.emit(ElementResource.new().setup(ElementResource.elementType.OBJECT,interactable_resource.item_name,interactable_resource.timeline,interactable_resource.description,get_sprite_from_current_frame()))



#region Persistence Methods
func saving() -> Dictionary:
	return {
		"persistent": true,
		"nodepath": get_path(),
		"parent": get_parent().get_path(),
		"resources": {
			"resource": resource,
		},
	}

func loading(input:Dictionary) -> bool:
	if input.has_all(["resources"]):
		if input["resources"].has("resource"):
			resource = input["resources"]["resource"]
		return true
	return false
#endregion
