class_name AudioManagerResource extends Resource


# A list of all available buses
enum buses {MASTER, SFX, MUSIC, DIALOGUE}

# Conversion dictionary from bus enum to bus address (for AudioStreamPlayer.bus variable)
const audioBusNameDictionary: Dictionary = {
	buses.MASTER: 	&"Master",
	buses.SFX: 		&"SFX",
	buses.MUSIC: 	&"Music",
	buses.DIALOGUE:	&"Dialogue",
}

# Audio folder location
const folderPath: String = "res://audio/"
const resourceFilename: String = "audio_manager_resource.res"

@export_group("Audio Manager Setup")
@export var importTracks: bool = true
@export var pitchVariance: bool = true
@export var pitchRange: Vector2 = Vector2(0.9,1.1)
@export_range(1,64,1) var maxSFXSounds: int = 5

@export_group("Audio Tracks")
@export var tracks: Dictionary

@export_group("Runtime Variables")
@export var  dialogueFinished: bool = true
@export var  sfxList: Array = []


#region Audio Track Import Methods
func import_audio_tracks() -> void:
	if not importTracks:
		return
	
	var folders: PackedStringArray
	var files: PackedStringArray
	
	if not DirAccess.dir_exists_absolute(folderPath):
		printerr("Error: Cannot import audio files as the '%s' folder does not exist." % [folderPath])
		return
	
	folders = DirAccess.get_directories_at(folderPath)
	
	for folder in folders:
		files = DirAccess.get_files_at(folderPath.path_join(folder))
		for file in files:
			if file.ends_with(".import"):
				continue
			import_track(folder, file)

func import_track(folder: String, file: String) -> void:
	var trackName: String = file.split(".")[0]
	var trackID: String = folder.path_join(trackName)
	
	if tracks.has(trackID):
		return
	
	var trackFilepath: String = folderPath.path_join(folder).path_join(file)
	
	if not FileAccess.file_exists(trackFilepath):
		printerr("Error: Audio file in filepath '%s' doesn't exist." % [trackFilepath])
		return
		
	var audioResource = load(trackFilepath)
	
	if not audioResource is AudioStream:
		printerr("Error: Audio file in filepath '%s' is not an Audio Track resource." % [trackFilepath])
		return
	
	tracks[trackID] = audioResource
#endregion

#region Track Methods
func track_exists(trackID: String) -> bool:
	if not tracks.has(trackID):
		print_rich("[color=yellow] Warning: Audio track of name '%s' doesn't exist." % [trackID])
		return false
	return true

func get_track(trackID: String) -> AudioStream:
	if not track_exists(trackID):
		return null
	return tracks[trackID]
#endregion
