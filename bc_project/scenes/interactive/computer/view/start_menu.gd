extends PopupMenu

@export var popup_offset: int = 68

func _ready() -> void:
	connect("about_to_popup",set_popup_offset)

func set_popup_offset() -> void:
	position.y = position.y - popup_offset
