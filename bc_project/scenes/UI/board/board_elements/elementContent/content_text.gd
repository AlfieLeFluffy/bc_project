extends ElementContentBase

"""
--- Setup Methods
"""
func _setup_content(_resource: ElementResource) -> void:
	resource = _resource
	setup_text()
	if not SettingsController.is_connected("retranslate", setup_text):
		SettingsController.connect("retranslate",setup_text)

func setup_text() -> void:
	%ObjectDescription.text = "[center]"+tr(resource.description)
