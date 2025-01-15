extends Node

"""
--- Bus Setup
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
--- Ready Functions Setup
"""
# Prepares all audio clips from the resource to be called upon
func _ready() -> void:
	if audioManRes:
		for track in audioManRes.sfxTracks:
			sfxTracks[track.name] = track.file
		for track in audioManRes.musicTracks:
			musicTracks[track.name] = track.file
		for track in audioManRes.dialogueTracks:
			dialogueTracks[track.name] = track.file

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
	
	# AudioStreamPlayer instantiation
	var audioPlayer = AudioStreamPlayer.new()
	add_child(audioPlayer)
	
	audio_player_setup(audioPlayer,busses.SFX,name,pitchVariance)
	run_sound(audioPlayer)

# Plays specified sound within the world
# If sound doesn't exist an error is printed and the call is terminated
# For every sound the manager creates a new AudioStreamPlayer
# Pitch variance option allows generation of a different pitch for given sound
func play_sound_2d(name: String, position: Vector2, pitchVariance: bool= true) -> void:
	
	# Checks if track exists 
	if not check_track(busses.SFX, name):
		return
	
	# AudioStreamPlayer2D instantiation
	var audioPlayer = AudioStreamPlayer2D.new()
	add_child(audioPlayer)
	
	audio_player_setup(audioPlayer,busses.SFX,name,pitchVariance)
	# Setup step for 2D audio position
	audioPlayer.position = position
	run_sound(audioPlayer)

# Checks if given audio track exists
# Returns false if search returns null, otherwise true
func check_track(bus: busses, name: String) -> bool:
	if not tracks[bus][name]:
		printerr("Audio file of name "+ name +" doesn't exist")
		return false
	return true

"""
--- General AudioStreamPlayer Functions
"""
# AudioStreamPlayer2D setup
func audio_player_setup(audioPlayer ,bus: busses, name: String, pitchVariance: bool= true) -> void:
	audioPlayer.bus = busDict[bus]
	audioPlayer.stream = tracks[bus][name]
	if pitchVariance:
		audioPlayer.pitch_scale = randf_range(audioManRes.pitchRange.x,audioManRes.pitchRange.y)

# Play sound, await till end of track and free audioPlayer after audio track finishes
func run_sound(audioPlayer) -> void:
	audioPlayer.play()
	await audioPlayer.finished
	audioPlayer.queue_free()
