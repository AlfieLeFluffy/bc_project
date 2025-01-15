class_name AudioManagerResource extends Resource

@export_group("Audio Manager Setup")
@export var pitchRange: Vector2

@export_group("Audio Tracks")
@export var sfxTracks: Array[AudioTrack]
@export var musicTracks: Array[AudioTrack]
@export var dialogueTracks: Array[AudioTrack]
