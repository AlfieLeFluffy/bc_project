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
#endregion

#region Setup Methods
"""
--- Setup Methods
"""
# Local ready function for instantiated objects
func local_ready() -> void:
	setup_computer_status()
	Signals.connect("shutdown_computer",shutdown_computer)
	Signals.connect("hide_computer_view",hide_computer_view)
	SettingsController.connect("retranslate",setup_interactable_info)

func setup_interactable_info() -> void:
	if compRes:
		name = compRes.computerName
		label.text = tr(compRes.computerName)

func setup_computer_status() -> void:
	if compRes.computerState:
		sprite.frame = 0
		return
	sprite.frame = 1
	return

#endregion

#region Runtime Methods
"""
--- Runtime Methods
"""
# Active function if no dialog detected
func interact_function(event: InputEvent) -> void:
	if not compRes.computerState:
		compRes.computerState = true
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
	get_tree().current_scene.add_child(view)
	view.setup_computer_view(self)

func shutdown_computer(computerName: String) -> void:
	if computerName == compRes.computerName:
		compRes.computerState = false
	setup_computer_status()

func hide_computer_view(computerName: String) -> void:
	if computerName == compRes.computerName and is_instance_valid(view):
		view.visible = not view.visible

# Active function if no dialog detected
func add_board_element(event: InputEvent) -> void:
	pass
	#Signals.emit_signal('create_board_element',BoardElementResource.elementType.TEXT,textRosource.textName,interactable_resource.timeline,get_sprite_from_current_frame(),textRosource.textContents)
#endregion
