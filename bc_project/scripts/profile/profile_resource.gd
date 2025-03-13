class_name ProfileResource extends Resource

@export_category("Informations")
@export var id: StringName
@export var profileName: StringName

@export_category("Achievemnts")
@export var achievements: AchievementsResource = AchievementsResource.new()

@export_category("Statistics")
@export var statistics: StatisticsResource = StatisticsResource.new()

#region Constants
const folderPath: String = "user://profiles"
#endregion

#region Setup
func setup(_profileName: StringName) -> void:
	id = create_id(_profileName)
	profileName = _profileName
#endregion

#region Save and Delete Methods
func save() -> void:
	var error = ResourceSaver.save(self, create_filepath_id(id))
	if error:
		printerr("Error: During saving of profile '%s' occured and error: " + str(error))

func delete() -> void:
	DirAccess.remove_absolute(create_filepath_id(id))
#endregion

#region Static Profile Menagment Methods
static func create_id(_profileName: String) -> String:
	return _profileName.strip_edges().to_lower().replace(" ","_").replace("/","_").replace(".","_")

static func create_filepath_id(id: String) -> String:
	return folderPath.path_join(id)+".tres"
	
static func create_filepath_filename(filename: String) -> String:
	return folderPath.path_join(filename)

static func get_available_profile_dict() -> Dictionary:
	var output: Dictionary = {}
	for filename in DirAccess.get_files_at(ProfileResource.folderPath):
		var loadedProfile = load(ProfileResource.create_filepath_filename(filename))
		if loadedProfile is ProfileResource:
			output[loadedProfile.id] = loadedProfile
	return output
#endregion
