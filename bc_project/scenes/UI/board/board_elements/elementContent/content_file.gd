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
	%ObjectDescription.text =  "[font_size=%s] %s" % [str(SettingsController.scale_font_size(FONT_SIZE)),tr(resource.description)]
