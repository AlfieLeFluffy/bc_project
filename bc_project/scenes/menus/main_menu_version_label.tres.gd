extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "[font_size=24]%s: %s   " % [tr("VERSION_LABEL"), ProjectSettings.get_setting("application/config/version")]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
