extends ElementContentBase

"""
--- Setup Methods
"""
func _setup_content(_resource: ElementResource) -> void:
	resource = _resource
	setup_text()
	if not SettingsController.is_connected("s_Retranslate", setup_text):
		SettingsController.s_Retranslate.connect(setup_text)

func setup_text() -> void:
	if resource.texture:
		%ObjectTexture.texture = resource.texture
	%ObjectDescription.text = "[center]"+tr(resource.description)
