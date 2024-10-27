extends "res://scenes/UI/board_elements/board_element_base.gd"

var texture
var label
var text

func element_setup() -> void:
	$ItemTexture.texture = texture
	$ItemLabel.text = label
	$RichTextLabel.text = text
