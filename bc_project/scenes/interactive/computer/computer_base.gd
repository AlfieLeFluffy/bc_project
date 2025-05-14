class_name ComputerBase extends Interactable

#region Variables, Constants, Signals and such
"""
--- Preload Constants
"""
const preloadComputerView = preload("res://scenes/interactive/computer/view/computer_view.tscn")

"""
--- Runtime Variables
"""
@export var compRes: ComputerObjectResource
@export var dirFileRes: DirectoryFileResource
@export var appRes: ApplicationResource
var view: ComputerView
var usersDictionary: Dictionary

#endregion

#region Setup Methods
"""
--- Setup Methods
"""
# Local ready function for instantiated objects
func _local_ready() -> void:
	setup_computer_status()
	setup_users_dictionary()
	Signals.s_ShutdownComputer.connect(shutdown_computer)
	Signals.s_HideComputerView.connect(hide_computer_view)
	SettingsController.s_Retranslate.connect(setup_interactable_info)

func setup_interactable_info() -> void:
	if compRes:
		name = compRes.name
		%Label.text = "[font_size=%s][color=#%s]%s" % [str(SettingsController.scale_font_size(28)),Global.color_TextHighlight.to_html(),tr(compRes.name)]

func setup_computer_status() -> void:
	if not compRes:
		return
	if compRes.state:
		%Sprite2D.frame = 0
		return
	%Sprite2D.frame = 1
	return

func setup_users_dictionary() -> void:
	if not compRes:
		return
	for user in compRes.users:
		if not user is UserResource:
			continue
		if user.username == null:
			continue
		usersDictionary[user.username] = user
#endregion



#region Runtime Methods
"""
--- Runtime Methods
"""
# Active function if no dialog detected
func _interact_function(event: InputEvent) -> void:
	if not compRes.state:
		compRes.state = true
		setup_computer_status()
		return
	else:
		open_computer_view()

func open_computer_view() -> void:
	if GameController.check_nongameplay_scene():
		return
	if is_instance_valid(view):
		view.visible = not view.visible
		return
	create_computer_view()

func create_computer_view() -> void:
	view = preloadComputerView.instantiate()
	view.computer = self
	get_tree().current_scene.add_child(view)
	view.setup_computer_view()

func shutdown_computer(computerName: String) -> void:
	if computerName == compRes.name:
		compRes.state = false
	setup_computer_status()

func hide_computer_view(computerName: String) -> void:
	if computerName == compRes.name+interactableResource.timeline and is_instance_valid(view):
		view.visible = not view.visible

# Active function if no dialog detected
func add_board_element(event: InputEvent) -> void:
	pass
	Signals.s_CreateBoardElement.emit(ElementResource.new().setup(ElementResource.elementType.OBJECT,compRes.name,interactableResource.timeline,interactableResource.description,get_sprite_from_current_frame()))
#endregion



#region Persistence Methods
func saving() -> Dictionary:
	return {
		"persistent": true,
		"nodepath": get_path(),
		"parent": get_parent().get_path(),
		"resources": {
			"computerResource": compRes,
		},
	}

func loading(input:Dictionary) -> bool:
	if input.has_all(["resources"]):
		if input["resources"].has("computerResource"):
			compRes = input["resources"]["computerResource"]
		return true
	return false
#endregion
