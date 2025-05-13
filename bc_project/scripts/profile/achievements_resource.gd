class_name AchievementsResource extends Resource

enum e_AchievementType {
	HOW_DID_WE_GET_HERE,
	RETIREMENT,
}

const information: Dictionary = {
	e_AchievementType.HOW_DID_WE_GET_HERE : {"name": "ACHIEVEMENT_HOW_DID_NAME", "name_color": "CYAN", "description": "ACHIEVEMENT_HOW_DID_DESCRIPTION", "icon": preload("res://textures/ui/achievements/how_did_i_get_here.png")},
	e_AchievementType.RETIREMENT: {"name": "ACHIEVEMENT_RETIREMENT_NAME", "name_color": "YELLOW", "description": "ACHIEVEMENT_RETIREMENT_DESCRIPTION", "icon": preload("res://textures/ui/achievements/retirement.png")},
}

@export var acquiredAchievements: Array[AchievementsResource.e_AchievementType] = []
@export var newAchievements: Array[AchievementsResource.e_AchievementType] = []

#region Achievement Managment Methdos
func set_achievement(_type: e_AchievementType) -> void:
	if not e_AchievementType.find_key(_type):
		printerr("Error: Cannot find achievement of e_AchievementType '%s' during set_achievemets." % str(_type))
		return
	if acquiredAchievements.has(_type):
		return
	acquiredAchievements.append(_type)
	acquiredAchievements.sort()
	newAchievements.append(_type)
	newAchievements.sort()

func reset_achievements() -> void:
	reset_acquired_achievements()
	reset_new_achievements()

func get_achievement_info(_type: e_AchievementType) -> Dictionary:
	return information[_type]
#endregion

#region Aquired Achievements Methods
func check_acquired_achievements() -> bool:
	return not acquiredAchievements.is_empty()

func get_acquired_achievements_count() -> int:
	return acquiredAchievements.size()

func get_acquired_achievements() -> Array[AchievementsResource.e_AchievementType]:
	return acquiredAchievements 

func reset_acquired_achievements() -> void:
	acquiredAchievements.clear()
#endregion

#region New Achievements Methods
func check_new_achievements() -> bool:
	return not newAchievements.is_empty()

func get_new_achievements_count() -> int:
	return newAchievements.size()

func get_new_achievements() -> Array[AchievementsResource.e_AchievementType]:
	return newAchievements 

func reset_new_achievements() -> void:
	newAchievements.clear()
#endregion
