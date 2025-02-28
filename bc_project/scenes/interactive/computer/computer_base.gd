extends "res://scenes/interactive/interactable.gd"

"""
--- Preload Constants
"""
const preloadComputerView = preload("res://scenes/interactive/computer/computer_view.tscn")

"""
--- Runtime Variables
"""
@export var computerRosource: ComputerObjectResource
var computerViewInstance: Node

# Local ready function for instantiated objects
func local_ready() -> void:
	setup_computer_status()
	SettingsController.connect("retranslate",setup_interactable_info)

func setup_interactable_info() -> void:
	if computerRosource:
		name = computerRosource.computerName
		label.text = tr(computerRosource.computerName)

func setup_computer_status() -> void:
	if computerRosource.computerState:
		sprite.frame = 0
		return
	sprite.frame = 1
	return

# Active function if no dialog detected
func interact_function(event: InputEvent) -> void:
	if GameController.check_nongameplay_scene():
		return
	computerViewInstance = preloadComputerView.instantiate()
	get_tree().current_scene.add_child(computerViewInstance)
	computerViewInstance.setup_computer_view(computerRosource.computerType,computerRosource.computerName)

# Active function if no dialog detected
func add_board_element(event: InputEvent) -> void:
	pass
	#Signals.emit_signal('create_board_element',BoardElementResource.elementType.TEXT,textRosource.textName,interactable_resource.timeline,get_sprite_from_current_frame(),textRosource.textContents)
