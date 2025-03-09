extends ElementBase

"""
--- Runtime Variables
"""

@onready var contentTexture: TextureRect = content.get_node("ObjectTexture")
@onready var contentDescription: RichTextLabel = content.get_node("ObjectDescription")


"""
--- Setup Methods
"""
func _setup_element() -> void:
	setup_text()
	if not SettingsController.is_connected("retranslate", setup_text):
		SettingsController.connect("retranslate",setup_text)

func setup_text() -> void:
	if resource.texture:
		contentTexture.texture = resource.texture
	contentDescription.text = "[center]"+tr(resource.description)
