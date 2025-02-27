extends "res://scenes/interactive/interactable.gd"

"""
--- Preload Constants
"""
const preloadTextView = preload("res://scenes/interactive/texts/text_view.tscn")

"""
--- Runtime Variables
"""
@export var textRosource: TextObjectResourse
var textViewInstance: Node

# Local ready function for instantiated objects
#func local_ready() -> void:
#	pass

func setup_interactable_info() -> void:
	if textRosource:
		name = textRosource.textName
		$Labels/Label.text = tr(textRosource.textName)

# Active function if no dialog detected
func interact_function(event: InputEvent) -> void:
	if GameController.check_nongameplay_scene():
		return
	textViewInstance = preloadTextView.instantiate()
	get_tree().current_scene.add_child(textViewInstance)
	textViewInstance.set_text_view(textRosource.textType,textRosource.textName,textRosource.textContents)

# Active function if no dialog detected
#func local_process(delta: float) -> void:
#	pass

# Active function if no dialog detected
func add_board_element(event: InputEvent) -> void:
	Signals.emit_signal('create_board_element',BoardElementResource.elementType.TEXT,textRosource.textName,interactable_resource.timeline,get_sprite_from_current_frame(),textRosource.textContents)
