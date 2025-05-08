class_name AchievementsMenu extends Control

const preloadAchievementLine = preload("res://scripts/profile/prefab/achievement_line.tscn")

var popupMenu: PopupMenuController

@export var profile: ProfileResource
var achievements: AchievementsResource
var lines: Dictionary

func _ready() -> void:
	popupMenu = PopupMenuController.get_popup_menu(self)
	
	%CancelButton.grab_focus()
	
	setup_menu()

func setup_menu():
	if not profile:
		if not profile.achievements:
			return
		return
	
	achievements = profile.achievements
	
	var all = achievements.e_AchievementType.duplicate()
	for attained in achievements.acquiredAchievements:
		add_line(attained, all, true)
	
	if not achievements.acquiredAchievements.is_empty():
		var separator = HSeparator.new()
		%AchievementsList.add_child(separator)
	
	for notattained in all.values():
		add_line(notattained, all, false)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_menu"):
		close_menu()
	
func add_line(type: AchievementsResource.e_AchievementType, all: Dictionary, attained:bool) -> void:
	var line = preloadAchievementLine.instantiate()
	line.info = achievements.information[type]
	line.attained = attained
	if attained:
		if achievements.newAchievements.has(type):
			line.flair = true
	all.erase(all.find_key(type))
	lines[type] = line
	profile.achievements.reset_new_achievements()
	%AchievementsList.add_child(line)

func close_menu():
	popupMenu.popdownKill.emit()

func _on_cancel_button_pressed() -> void:
	close_menu()
