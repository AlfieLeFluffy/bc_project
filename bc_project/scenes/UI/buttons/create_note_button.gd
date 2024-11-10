extends TextureButton

func _ready() -> void:
	$RichTextLabel.visible = false

func _on_mouse_entered() -> void:
	$RichTextLabel.visible = true
	
func _on_mouse_exited() -> void:
	$RichTextLabel.visible = false
