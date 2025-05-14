class_name TextInteraactable extends Interactable

"""
--- Preload Constants
"""
const preload_TextViewPaper = preload("res://scenes/interactive/texts/view/text_view_paper.tscn")
const preload_TextViewBook = preload("res://scenes/interactive/texts/view/text_view_book.tscn")
const preload_TextViewNote = preload("res://scenes/interactive/texts/view/text_view_note.tscn")

"""
--- Runtime Variables
"""
@export var textRosource: TextObjectResourse
var textViewInstance: Node

# Local ready function for instantiated objects
#func _local_ready() -> void:
#	pass

func setup_interactable_info() -> void:
	if textRosource:
		if textRosource.textName:
			name = textRosource.textName
			%Label.text = "[font_size=%s][color=#%s]%s" % [str(SettingsController.scale_font_size(28)),Global.color_TextHighlight.to_html(),tr(textRosource.textName)]

# Active function if no dialog detected
func _interact_function(event: InputEvent) -> void:
	if GameController.check_nongameplay_scene():
		return
	match textRosource.textType:
		TextObjectResourse.textTypeEnum.PAPER:
			textViewInstance = preload_TextViewPaper.instantiate()
		TextObjectResourse.textTypeEnum.BOOK:
			textViewInstance = preload_TextViewBook.instantiate()
		TextObjectResourse.textTypeEnum.NOTE:
			textViewInstance = preload_TextViewNote.instantiate()
		_:
			textViewInstance = preload_TextViewNote.instantiate()
	get_tree().current_scene.add_child(textViewInstance)
	textViewInstance.setup_text_view(textRosource)
	textViewInstance.create_board_element_text.connect(add_board_element)

# Active function if no dialog detected
#func _local_process(delta: float) -> void:
#	pass

# Active function if no dialog detected
func add_board_element(event: InputEvent) -> void:
	Signals.s_CreateBoardElement.emit(ElementResource.new().setup(ElementResource.elementType.TEXT,textRosource.textName,interactableResource.timeline,textRosource.textContents,get_sprite_from_current_frame()))
