class_name AchievementLine extends HBoxContainer

@export var info: Dictionary
@export var attained: bool = false
@export var flair: bool = false

const ACHIEVEMENT_TEXT_FORMAT_STRING: String = "[color=%s]%s[/color]\n[font_size=14][color=%s]%s[/color]"

func _ready() -> void:
	SettingsController.s_Retranslate.connect(setup_line)
	setup_line()
	
func setup_line() -> void:
	if not info:
		return
	
	if info.has("icon"):
		if info["icon"] != null:
			%Icon.texture = info["icon"]
	
	if flair:
		%Flair.visible = true
	else:
		%Flair.visible = false
	
	if info.has_all(["name","description"]):
		if attained:
			if info.has("name_color"):
				%Text.text = ACHIEVEMENT_TEXT_FORMAT_STRING % [info["name_color"], tr(info["name"]), "WHITE", tr(info["description"])]
			else:
				%Text.text = ACHIEVEMENT_TEXT_FORMAT_STRING % ["WHITE", tr(info["name"]), "WHITE", tr(info["description"])]
		else:
			%Text.text = ACHIEVEMENT_TEXT_FORMAT_STRING % ["GRAY", tr(info["name"]), "GRAY", tr(info["description"])]
