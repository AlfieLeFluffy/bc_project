class_name AchievementsResource extends Resource

enum type {
	RETIREMENT,
}

const information: Dictionary = {
	type.RETIREMENT: {"name": "ACHIEVEMENT_RETIREMENT_NAME", "description": "ACHIEVEMENT_RETIREMENT_DESCRIPTION", "icon": null},
}

@export var acquiredAchievements: Array[AchievementsResource.type] = []
@export var newAchievements: Array[AchievementsResource.type] = []

#region Achievement Managment Methdos
func set_achievement(_type: type) -> void:
	if not type.find_key(_type):
		printerr("Error: Cannot find achievement of type '%s' during set_achievemets." % str(_type))
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

func get_achievement_info(_type: type) -> Dictionary:
	return information[_type]
#endregion

#region Aquired Achievements Methods
func check_acquired_achievements() -> bool:
	return not acquiredAchievements.is_empty()

func get_acquired_achievements_count() -> int:
	return acquiredAchievements.size()

func get_acquired_achievements() -> Array[AchievementsResource.type]:
	return acquiredAchievements 

func reset_acquired_achievements() -> void:
	acquiredAchievements.clear()
#endregion

#region New Achievements Methods
func check_new_achievements() -> bool:
	return not newAchievements.is_empty()

func get_new_achievements_count() -> int:
	return newAchievements.size()

func get_new_achievements() -> Array[AchievementsResource.type]:
	return newAchievements 

func reset_new_achievements() -> void:
	newAchievements.clear()
#endregion
