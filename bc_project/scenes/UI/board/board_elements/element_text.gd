extends ElementBase

"""
--- Runtime Variables
"""

@onready var contentDescription: RichTextLabel = content.get_node("ObjectDescription")
"""
--- Setup Methods
"""
func _setup_element() -> void:
	SettingsController.connect("retranslate",setup_text)

func setup_text() -> void:
	contentDescription.text = "[center]"+tr(resource.description)
