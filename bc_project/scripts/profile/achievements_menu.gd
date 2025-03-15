class_name AchievementsMenu extends CanvasLayer

const preloadAchievementLine = preload("res://scripts/profile/prefab/achievement_line.tscn")

var popupMenu: PopupMenuController

@export var profile: ProfileResource
var achievements: AchievementsResource
var lines: Dictionary

func _ready() -> void:
	popupMenu = PopupMenuController.get_popup_menu(self)
	
	setup_menu()

func setup_menu():
	if not profile:
		if not profile.achievements:
			return
		return
	
	achievements = profile.achievements
	
	var all = achievements.information.duplicate()
	for attained in achievements.acquiredAchievements:
		add_line(attained, all, true)
	
	var separator = HSeparator.new()
	%AchievementsList.add_child(separator)
	
	for notattained in all:
		add_line(notattained, all, false)
	
func add_line(type: AchievementsResource.type, all: Dictionary, attained:bool) -> void:
	var line = preloadAchievementLine.instantiate()
	line.info = achievements.information[type]
	line.attained = attained
	if attained:
		if achievements.newAchievements.has(type):
			line.flair = true
	all.erase(type)
	lines[type] = line
	profile.achievements.reset_new_achievements()
	%AchievementsList.add_child(line)

func close_menu():
	popupMenu.popdownKill.emit()

func _on_cancel_button_pressed() -> void:
	close_menu()
