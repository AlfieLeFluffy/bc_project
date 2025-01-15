extends Node

"""
--- Bus and Folder Setup
"""

# A list of all available busses
enum busses {Master, SFX, Music, Dialogue}
# Conversion dictionary from bus enum to bus address (for AudioStreamPlayer.bus variable)
const busDict: Dictionary = {
	busses.Master: &"Master",
	busses.SFX: &"SFX",
	busses.Music: &"Music",
	busses.Dialogue: &"Dialogue"
}

const folders = ["sfx", "music", "dialogue"]

"""
--- Audio Manager and Tracks Resources
"""
# Exported resource for audio manager setup
@export_group("Audio Manager Resource")
@export var audioManRes: AudioManagerResource

"""
--- Track Dictionaries
"""
# Internal dictionaries to hold and sort through audio tracks
@onready var sfxTracks: Dictionary
@onready var musicTracks: Dictionary
@onready var dialogueTracks: Dictionary
# Internal dictionary for sorting through audio track dictionaries
@onready var tracks: Dictionary = {
	busses.Master: null,
	busses.SFX: sfxTracks,
	busses.Music: musicTracks,
	busses.Dialogue: dialogueTracks
}

"""
--- Control variable and flags
"""
var sfxCount:int = 0
var sfxPlayerList: Array = []
var musicFinished:bool = true
var dialogueFinished:bool = true

"""
--- Ready Functions Setup
"""
# Prepares all audio clips from the resource to be called upon
func _ready() -> void:

	if audioManRes.importTracks:
		import_audio_file_from_folder()

	if audioManRes:
		for track in audioManRes.sfxTracks:
			if not sfxTracks.has(track.name):
				sfxTracks[track.name] = track.file
		for track in audioManRes.musicTracks:
			if not musicTracks.has(track.name):
				musicTracks[track.name] = track.file
		for track in audioManRes.dialogueTracks:
			if not dialogueTracks.has(track.name):
				dialogueTracks[track.name] = track.file
	
	sfxPlayerList.resize(Global.MaxSFXSounds)

func import_audio_file_from_folder() -> void:
	var files
	for i in range(folders.size()):
		files = DirAccess.get_files_at("res://audio/"+folders[i])
		for file in files:
			var fileName = file.rstrip(".mp3")
			if not import_audio_track(folders[i], file, fileName, tracks[i+1]):
				printerr("Audio track by name " + file + "could not be loaded")

func import_audio_track(folder, file, fileName, directory) -> bool:
	if not sfxTracks.has(fileName):
		var audioStream = AudioStreamMP3.new()
		var fileStream = FileAccess.open("res://audio/"+folder+"/"+file, FileAccess.READ)
		if fileStream:
			audioStream.data = fileStream.get_buffer(fileStream.get_length())
			directory[fileName] = audioStream
			return true
	return false

"""
--- Play SFX Sounds
"""
# Plays specified sound flat (without being placed in the world)
# If sound doesn't exist an error is printed and the call is terminated
# For every sound the manager creates a new AudioStreamPlayer
# Pitch variance option allows generation of a different pitch for given sound
func play_sound(name: String, pitchVariance: bool= true) -> void:
	
	# Checks if track exists 
	if not check_track(busses.SFX,name):
		return
	
	# Checks for sfx limit and return if exceded
	if check_count():
		return
	change_count(1)
	
	# AudioStreamPlayer instantiation
	var audioPlayer = AudioStreamPlayer.new()
	add_child(audioPlayer)
	
	audio_player_setup(audioPlayer,busses.SFX,name,pitchVariance)
	await run_sound(audioPlayer)
	finish_sound()

# Plays specified sound within the world
# If sound doesn't exist an error is printed and the call is terminated
# For every sound the manager creates a new AudioStreamPlayer
# Pitch variance option allows generation of a different pitch for given sound
func play_sound_2d(name: String, position: Vector2, pitchVariance: bool= true) -> void:
	
	# Checks if track exists 
	if not check_track(busses.SFX, name):
		return
	
	# Checks for sfx limit and return if exceded
	if check_count():
		return
	change_count(1)
	
	# AudioStreamPlayer2D instantiation
	var audioPlayer = AudioStreamPlayer2D.new()
	add_child(audioPlayer)
	
	audio_player_setup(audioPlayer,busses.SFX,name,pitchVariance)
	# Setup step for 2D audio position
	audioPlayer.position = position
	await run_sound(audioPlayer)
	finish_sound()

"""
--- Play Dialog Sounds
"""
# 
func play_dialog(name: String, skipDialogue: bool = true, pitchVariance: bool= true) -> void:
	
	# Checks if track exists 
	if not check_track(busses.Dialogue,name):
		return
	
	# Checks if dialogue is running and skipDialog is dissabled returns this call
	if not dialogueFinished and not skipDialogue:
		return
	
	# Checks if dialogue is running and skipDialog is enabled then terminates previous dialogue and starts a new one
	if not dialogueFinished and skipDialogue:
		$DialogAudioStreamPlayer.stop()
	
	dialogueFinished = false
	
	# Sets up and runs the dialogue audio
	audio_player_setup($DialogAudioStreamPlayer,busses.Dialogue,name,pitchVariance)
	run_sound($DialogAudioStreamPlayer)

func play_dialog_2d(name: String, position: Vector2, pitchVariance: bool= true) -> void:
	
	# Checks if track exists 
	if not check_track(busses.Dialogue,name):
		return
	
	# AudioStreamPlayer instantiation
	var audioPlayer = AudioStreamPlayer.new()
	add_child(audioPlayer)
	
	audio_player_setup(audioPlayer,busses.Dialogue,name,pitchVariance)
	# Setup step for 2D audio position
	audioPlayer.position = position
	run_sound(audioPlayer)

"""
--- General AudioStreamPlayer Functions
"""
# Checks if given audio track exists
# Returns false if search returns null, otherwise true
func check_track(bus: busses, name: String) -> bool:
	if not tracks[bus].has(name):
		printerr("Audio track of name "+ name +" doesn't exist")
		return false
	return true

# AudioStreamPlayer2D setup
func audio_player_setup(audioPlayer ,bus: busses, name: String, pitchVariance: bool= true) -> void:
	sfxPlayerList[sfxCount-1] = audioPlayer
	audioPlayer.bus = busDict[bus]
	audioPlayer.stream = tracks[bus][name]
	if pitchVariance:
		audioPlayer.pitch_scale = randf_range(audioManRes.pitchRange.x,audioManRes.pitchRange.y)

# Play sound, await till end of track and free audioPlayer after audio track finishes
func run_sound(audioPlayer) -> void:
	sfxPlayerList[sfxPlayerList.find(audioPlayer)] = null
	audioPlayer.play()
	await audioPlayer.finished
	audioPlayer.queue_free()


"""
--- SFX Audio Limit Functions
"""
func change_count(x:int) -> void:
	sfxCount = max(0, sfxCount + x)

func check_count() -> bool:
	if sfxCount >= Global.MaxSFXSounds:
		return true
	return false

func finish_sound() -> void:
	change_count(-1)

"""
--- Signals
"""
func _on_dialog_audio_stream_player_finished() -> void:
	dialogueFinished = true
