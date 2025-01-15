class_name AudioManagerResource extends Resource

@export_group("Audio Manager Setup")
@export var importTracks: bool = true
@export var pitchRange: Vector2

@export_group("Static Audio Tracks")
@export var sfxTracks: Array[AudioTrack]
@export var musicTracks: Array[AudioTrack]
@export var dialogueTracks: Array[AudioTrack]
