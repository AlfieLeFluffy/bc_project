extends RichTextLabel

func _ready() -> void:
	text = "[font_size=24]%s: %s" % [tr("VERSION_LABEL"), ProjectSettings.get_setting("application/config/version")]
