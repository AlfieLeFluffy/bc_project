class_name AchievementsResource extends Resource

enum type {
	RETIREMENT,
}

const achievementInfo: Dictionary = {
	type.RETIREMENT: {"name": "ACHIEVEMENT_RETIREMENT_NAME", "description": "ACHIEVEMENT_RETIREMENT_DESCRIPTION", "icon": null},
}

var attained: Array = [type.RETIREMENT]

#region Constants
const achievementsFolderPath: String = "user://achievements"
#endregion

#region Save Methods
func save(_id: String) -> void:
	var error = ResourceSaver.save(self, create_filepath_id(_id))
	if error:
		printerr("Error: During saving of achievements for profile '%s' occured and error: " % _id + str(error))
#endregion

#region Static Achievements Managment Methods
static func create_filepath_id(id: String) -> String:
	return achievementsFolderPath.path_join(id)+"_achievements.tres"
	
static func create_filepath_filename(filename: String) -> String:
	return achievementsFolderPath.path_join(filename)
#endregion
