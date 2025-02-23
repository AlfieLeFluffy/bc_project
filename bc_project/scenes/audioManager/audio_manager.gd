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
	
	DialogueManager.connect("dialogue_ended",end_dialogue)
	
func import_audio_file_from_folder() -> void:
	var files
	for i in range(folders.size()):
		files = DirAccess.get_files_at("res://audio/"+folders[i])
		for file in files:
			var fileName = file.rstrip(".mp3")
			if file.ends_with(".import"):
				pass
			elif not import_audio_track(folders[i], file, fileName, tracks[i+1]):
				printerr("Audio track by name " + file + "could not be loaded")

func import_audio_track(folder, file, fileName, directory) -> bool:
	if not sfxTracks.has(fileName):
		"""
		var audioStream = AudioStreamMP3.new()
		var fileStream = FileAccess.open("res://audio/"+folder+"/"+file, FileAccess.READ)
		if fileStream:
			audioStream.data = fileStream.get_buffer(fileStream.get_length())
			directory[fileName] = audioStream
			return true
		"""
		if FileAccess.file_exists("res://audio/"+folder+"/"+file):
			var audioStream = load("res://audio/"+folder+"/"+file)
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
func play_sound(soundName: String, pitchVariance: bool= true) -> void:
	
	# Checks if track exists 
	if not check_track(busses.SFX,soundName):
		return
	
	# Checks for sfx limit and return if exceded
	if check_count():
		return
	change_count(1)
	
	# AudioStreamPlayer instantiation
	var audioPlayer = AudioStreamPlayer.new()
	add_child(audioPlayer)
	
	audio_player_setup(audioPlayer,busses.SFX,soundName,pitchVariance)
	await run_sound(audioPlayer)
	finish_sound()

# Plays specified sound within the world
# If sound doesn't exist an error is printed and the call is terminated
# For every sound the manager creates a new AudioStreamPlayer
# Pitch variance option allows generation of a different pitch for given sound
func play_sound_2d(soundName: String, position: Vector2, pitchVariance: bool= true) -> void:
	
	# Checks if track exists 
	if not check_track(busses.SFX, soundName):
		return
	
	# Checks for sfx limit and return if exceded
	if check_count():
		return
	change_count(1)
	
	# AudioStreamPlayer2D instantiation
	var audioPlayer = AudioStreamPlayer2D.new()
	add_child(audioPlayer)
	
	audio_player_setup(audioPlayer,busses.SFX,soundName,pitchVariance)
	# Setup step for 2D audio position
	audioPlayer.position = position
	await run_sound(audioPlayer)
	finish_sound()

"""
--- Play Dialog Sounds
"""
# 
func play_dialogue(dialogName: String, skipDialogue: bool = true, pitchVariance: bool= true) -> void:
	
	# Checks if track exists 
	if not check_track(busses.Dialogue,dialogName):
		return
	
	# Checks if dialogue is running and skipDialog is dissabled returns this call
	if not dialogueFinished and not skipDialogue:
		return
	
	# Checks if dialogue is running and skipDialog is enabled then terminates previous dialogue and starts a new one
	if not dialogueFinished and skipDialogue:
		$DialogAudioStreamPlayer.stop()
	
	dialogueFinished = false
	
	# Sets up and runs the dialogue audio
	audio_player_setup($DialogAudioStreamPlayer,busses.Dialogue,dialogName,pitchVariance)
	run_dialog($DialogAudioStreamPlayer, false)

func play_dialogue_2d(dialogName: String, position: Vector2, pitchVariance: bool= true) -> void:
	
	# Checks if track exists 
	if not check_track(busses.Dialogue,dialogName):
		return
	
	# AudioStreamPlayer instantiation
	var audioPlayer = AudioStreamPlayer.new()
	add_child(audioPlayer)
	
	audio_player_setup(audioPlayer,busses.Dialogue,dialogName,pitchVariance)
	# Setup step for 2D audio position
	audioPlayer.position = position
	run_sound(audioPlayer)

func end_dialogue(resource: DialogueResource):
	$DialogAudioStreamPlayer.stop()

"""
--- Play Music
"""
func play_music(musicName: String, fade:bool = false, loop:bool = true, pitchVariance: bool= true) -> void:
	$MusicAudioStreamPlayer.stream = tracks[busses.Music][musicName]
	tracks[busses.Music][musicName].loop = loop
	if pitchVariance:
		$MusicAudioStreamPlayer.pitch_scale = randf_range(audioManRes.pitchRange.x,audioManRes.pitchRange.y)
	$MusicAudioStreamPlayer.play()

func pause_music() -> void:
	if not $MusicAudioStreamPlayer.stream_paused:
		$MusicAudioStreamPlayer.stream_paused = true

func resume_music() -> void:
	if $MusicAudioStreamPlayer.stream_paused:
		$MusicAudioStreamPlayer.stream_paused = false

func stop_music() -> void:
	if $MusicAudioStreamPlayer.playing:
		$MusicAudioStreamPlayer.stop()

func change_music(musicName: String) -> void:
	if check_track(busses.Music,musicName):
		$MusicAudioStreamPlayer.stream = tracks[busses.Music][musicName]
	$MusicAudioStreamPlayer.play()

"""
--- General AudioStreamPlayer Functions
"""
# Checks if given audio track exists
# Returns false if search returns null, otherwise true
func check_track(bus: busses, trackName: String) -> bool:
	if not tracks[bus].has(trackName):
		print_rich("[color=yellow] Warning: Audio track of name "+ trackName +" doesn't exist")
		return false
	return true

# AudioStreamPlayer2D setup
func audio_player_setup(audioPlayer ,bus: busses, trackName: String, pitchVariance: bool= true) -> void:
	sfxPlayerList[sfxCount-1] = audioPlayer
	audioPlayer.bus = busDict[bus]
	audioPlayer.stream = tracks[bus][trackName]
	if pitchVariance:
		audioPlayer.pitch_scale = randf_range(audioManRes.pitchRange.x,audioManRes.pitchRange.y)

# Play sound, await till end of track and free audioPlayer after audio track finishes
func run_sound(audioPlayer, freePlayer: bool = true) -> void:
	sfxPlayerList[sfxPlayerList.find(audioPlayer)] = null
	audioPlayer.play()
	await audioPlayer.finished
	audioPlayer.queue_free()

# Play dialog, await till end of track and free audioPlayer after audio track finishes
func run_dialog(audioPlayer, freePlayer: bool = false) -> void:
	audioPlayer.play()

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
--- Bus Managnemnt Methods
"""
# Creates a bus and reroutes its output to specified bus
# Created bus is appended as last bus
func create_bus(sendBus:busses) -> void:
	AudioServer.add_bus(AudioServer.bus_count)
	AudioServer.set_bus_send(AudioServer.bus_count, AudioServer.get_bus_name(sendBus))

# Deletes a specified bus
# If bus index is not specified it deletes the last bus
func delete_bus(busIndex:int = -1) -> void:
	if busIndex == -1:
		AudioServer.remove_bus(AudioServer.bus_count-1)
	else:
		AudioServer.remove_bus(busIndex)

"""
--- Base Bus Managnemnt Methods
"""
func get_bus_enum(busName: String) -> busses:
	return busses.get(busName)

# Returns bus volume as linear transformation float (converts from db scale)
# If linearOutput is set to false; returns volume as db scale
func get_bus_volume(bus:busses, linearOutput:bool = true) -> float:
	if linearOutput:
		return db_to_linear(AudioServer.get_bus_volume_db(bus))
	return AudioServer.get_bus_volume_db(bus)

# Sets bus volume from linear float (converts into db scale)
# If linearInput is set to false; set volume as db scale (doesn't convert)
func set_bus_volume(bus:busses, x:float, linearInput:bool = true) -> void:
	if linearInput:
		AudioServer.set_bus_volume_db(bus, linear_to_db(x))
	else:
		AudioServer.set_bus_volume_db(bus, x)

# Resets bus volume to 0 db
func reset_bus_volume(bus:busses) -> void:
	set_bus_volume(bus, 0.0)

# Resets all busses volume to 0 db
func reset_all_bus_volume(bus:busses) -> void:
	for i in range(AudioServer.bus_count):
		set_bus_volume(i, 0.0)

# Mutes specified bus
func mute_bus_volume(bus:busses) -> void:
	if AudioServer.is_bus_mute(bus):
		AudioServer.set_bus_mute(bus, false)

# Unmutes specified bus
func unmute_bus_volume(bus:busses) -> void:
	if not AudioServer.is_bus_mute(bus):
		AudioServer.set_bus_mute(bus, true)

# Fades in sounds on a specified bus
func fade_in_bus(bus, endVolume:float, baseVolume:float = 0, step:float = .25) -> void:
	var tween = create_tween().bind_node(bus)
	tween.tween_method(set_bus_volume, baseVolume, endVolume, step)

# Fades out sounds on a specified bus
func fade_out_bus(bus, baseVolume:float, endVolume:float= 0, step:float = .25) -> void:
	var tween = create_tween().bind_node(bus)
	tween.tween_method(set_bus_volume, baseVolume, endVolume, step)

"""
--- Effects Bus Managnemnt Methods
"""
# Adds an effect to a specified bus to a specified index
# The effect has to create beforehand
# If index is not given it automatically appends it
func add_bus_effect(bus:busses, effect:AudioEffect, index:int = -1) -> void:
	if index == -1:
		AudioServer.add_bus_effect(bus,effect,AudioServer.get_bus_effect_count(bus))
	else:
		AudioServer.add_bus_effect(bus,effect,index)

# Removes an effect from a specified bus on a specified index
# If index is not given it defaults into the last effect
func remove_bus_effect(bus:busses, index:int = -1) -> void:
	if not check_bus_effect(bus, index):
		return
	
	if index == -1:
		AudioServer.remove_bus_effect(bus,AudioServer.get_bus_effect_count(bus)-1)
	else:
		AudioServer.remove_bus_effect(bus,index)

# Exchanges a bus effect for another one
# If index is not given it defaults into the last effect
func change_bus_effect(bus:busses, effect:AudioEffect, index:int = -1) -> void:
	if not check_bus_effect(bus, index):
		return
	
	remove_bus_effect(bus, index)
	add_bus_effect(bus, effect, index)

# Clears all effects on a bus
func clear_bus_effect_all(bus:busses) -> void:
	for i in range(AudioServer.get_bus_effect_count(bus)):
		remove_bus_effect(bus)

# Clears all effects on all buses
func clear_all_bus_effect_all() -> void:
	for i in range(AudioServer.bus_count):
		clear_bus_effect_all(i)

# Checks for existence of given bus effect
func check_bus_effect(bus, index) -> bool:
	if index == -1:
		index = AudioServer.get_bus_effect_count(bus) -1
	if not AudioServer.get_bus_effect(bus, index):
		printerr("Given effect index " + index + " on bus " + bus + "doesn't exist. Out of bounds error.")
		return false
	return true 


"""
--- Signals
"""
func _on_dialog_audio_stream_player_finished() -> void:
	dialogueFinished = true
