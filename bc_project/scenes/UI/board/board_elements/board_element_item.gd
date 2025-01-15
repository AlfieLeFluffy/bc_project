extends "res://scenes/UI/board/board_elements/board_element_base.gd"

var texture
var label
var text
var timeline

func element_setup() -> void:
	$ItemTexture.texture = texture
	$ItemLabel.text = label
	$RichTextLabel.text = text
