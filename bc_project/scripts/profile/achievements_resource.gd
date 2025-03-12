class_name AchievementsResource extends Resource


const achievementsFolderPath: String = "user://achievements"

func save(_id: String) -> void:
	var error = ResourceSaver.save(self, create_filepath_id(_id))
	if error:
		printerr("Error: During saving of profile '%s' occured and error: " + str(error))

static func create_filepath_id(id: String) -> String:
	return achievementsFolderPath.path_join(id)+"_achievements.tres"
	
static func create_filepath_filename(filename: String) -> String:
	return achievementsFolderPath.path_join(filename)
