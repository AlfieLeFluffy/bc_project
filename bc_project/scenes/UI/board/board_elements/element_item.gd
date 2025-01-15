extends "res://scenes/UI/board/board_elements/element_base.gd"

"""
--- Runtime Variables
"""
var texture
var label
var text
var timeline

"""
--- Setup Methods
"""
func element_setup() -> void:
	$ItemTexture.texture = texture
	$ItemLabel.text = label
	$RichTextLabel.text = text
