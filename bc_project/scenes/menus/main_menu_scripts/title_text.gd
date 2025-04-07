extends RichTextLabel

const TITLE_STRING = "[font_size=%s][color=#%s]%s"

func _ready() -> void:
	parse_bbcode(TITLE_STRING % [str(48),Global.color_Highlight.to_html(),ProjectSettings.get_setting("application/config/name")])
