extends CanvasLayer

"""
--- Runtime Variables
"""
@onready var textLabel: Label = $Control/TextName
@onready var textContentsLabel: RichTextLabel = $Control/TextContents

var type: TextObjectResourse.textTypeEnum
var textName: String
var textContent: String

func set_text_view(_textType: TextObjectResourse.textTypeEnum,_textName:String, _textContent:String) -> void:
	type = _textType
	textName = _textName
	textContent = _textContent
	
	textLabel.text = tr(textName)
	textContentsLabel.text = tr(textContent)

func _on_back_button_pressed() -> void:
	queue_free()
