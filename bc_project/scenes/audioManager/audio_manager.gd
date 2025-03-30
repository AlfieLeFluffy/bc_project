extends Node

@export_category("Audio Manager Resource")
# Exported resource for audio manager setup
@export var res: AudioManagerResource

"""
--- Setup Methods
"""
#region Setup Methods
# Prepares all audio clips from the resource to be called upon
func _ready() -> void:
	if not setup_resource():
		printerr("Error: Could not load or create an Audio Manager Resource.")
		return
	
	if res:
		res.import_audio_tracks()
	
	DialogueManager.dialogue_ended.connect(end_dialogue)
	get_viewport().tree_exiting.connect(save_resource)

func setup_resource() -> bool:
	var resourceFilepath: String = AudioManagerResource.folderPath.path_join(AudioManagerResource.resourceFilename)
	
	if res:
		return true
	
	if FileAccess.file_exists(resourceFilepath):
		if not load_resource(resourceFilepath):
			return false
		return true
	elif not FileAccess.file_exists(resourceFilepath):
		if not create_resouce(resourceFilepath):
			return false
		return true
	
	return true

func create_resouce(filepath: String) -> bool:
	res = AudioManagerResource.new()
	if not save_resource():
		return false
	return true

func save_resource() -> bool:
	var resourceFilepath: String = AudioManagerResource.folderPath.path_join(AudioManagerResource.resourceFilename)
	var error = ResourceSaver.save(res, resourceFilepath)
	if error:
		printerr("Error: Cannot save Audio Manager Resource at location '%s'  due to error '%s'" % [resourceFilepath,str(error)])
		return false
	return true

func load_resource(filepath: String) -> bool:
	res = ResourceLoader.load(filepath)
	if res == null or not res is AudioManagerResource:
		printerr("Error: Cannot load Audio Manager Resource at location '%s' and Resource Loader returned '%s'" % [filepath, res])
		return false
	return true
#endregion



"""
--- Audio Track and Play Methods
"""
#region Audio Stream Methods
# AudioStreamPlayer setup
func setup_audio_player(audioPlayer: AudioStreamPlayer, trackID: String, bus: AudioManagerResource.busses = res.busses.MASTER, pitchOverride: bool = false) -> void:
	audioPlayer.bus = res.audioBusNameDictionary[bus]
	audioPlayer.stream = res.get_track(trackID)
	
	if res.pitchVariance and not pitchOverride:
		audioPlayer.pitch_scale = randf_range(res.pitchRange.x,res.pitchRange.y)

# AudioStreamPlayer setup
func setup_audio_player_2d(audioPlayer: AudioStreamPlayer2D, trackID: String, bus: AudioManagerResource.busses = res.busses.MASTER, pitchOverride: bool = false) -> void:
	audioPlayer.bus = res.audioBusNameDictionary[bus]
	audioPlayer.stream = res.get_track(trackID)
	
	if res.pitchVariance and not pitchOverride:
		audioPlayer.pitch_scale = randf_range(res.pitchRange.x,res.pitchRange.y)

# Play sound, await till end of track and free audioPlayer after audio track finishes
func run_sound(audioPlayer, free: bool = false) -> bool:
	audioPlayer.play()
	await audioPlayer.finished
	if free:
		audioPlayer.queue_free()
	return true
#endregion


#region Sound Effect Restriction Methods
func attempt_sfx() -> bool:
	if res.sfxList.size() >= res.maxSFXSounds:
		return false
	return true
#endregion


#region Sound Effect (SFX) Methods
# Plays specified sound flat (without being placed in the world)
# If sound doesn't exist an error is printed and the call is terminated
# For every sound the manager creates a new AudioStreamPlayer
# Pitch variance option allows generation of a different pitch for given sound
func play_sound(trackID: String) -> void:
	
	# Checks for sfx limit and return if exceded
	if not attempt_sfx():
		return
	
	# AudioStreamPlayer instantiation
	var audioPlayer = AudioStreamPlayer.new()
	add_child(audioPlayer)
	res.sfxList.append(audioPlayer)
	
	setup_audio_player(audioPlayer, trackID, AudioManagerResource.busses.SFX)
	await run_sound(audioPlayer)
	res.sfxList.erase(audioPlayer)
	audioPlayer.queue_free()

# Plays specified sound within the world
# If sound doesn't exist an error is printed and the call is terminated
# For every sound the manager creates a new AudioStreamPlayer
# Pitch variance option allows generation of a different pitch for given sound
func play_sound_2d(trackID: String, parent: Node2D) -> void:
	
	# Checks for sfx limit and return if exceded
	if not attempt_sfx():
		return
	
	# AudioStreamPlayer instantiation
	var audioPlayer = AudioStreamPlayer2D.new()
	parent.add_child(audioPlayer)
	res.sfxList.append(audioPlayer)
	
	setup_audio_player_2d(audioPlayer, trackID, AudioManagerResource.busses.SFX)
	await run_sound(audioPlayer)
	res.sfxList.erase(audioPlayer)
	audioPlayer.queue_free()
#endregion


#region Voice Acting (Dialogue) Methods
# 
func play_dialogue(trackID: String, skipDialogue: bool = true) -> void:
	
	# Checks if dialogue is running and skipDialog is dissabled returns this call
	if not res.dialogueFinished and not skipDialogue:
		return
	
	# Checks if dialogue is running and skipDialog is enabled then terminates previous dialogue and starts a new one
	if not res.dialogueFinished and skipDialogue:
		%DialogAudioStreamPlayer.stop()
	
	res.dialogueFinished = false
	
	# Sets up and runs the dialogue audio
	setup_audio_player(%DialogAudioStreamPlayer, trackID, AudioManagerResource.busses.DIALOGUE,true)
	run_sound(%DialogAudioStreamPlayer)

func play_dialogue_2d(trackID: String, parent: Node2D) -> void:
	
	# AudioStreamPlayer instantiation
	var audioPlayer = AudioStreamPlayer2D.new()
	parent.add_child(audioPlayer)
	
	setup_audio_player_2d(audioPlayer, trackID, AudioManagerResource.busses.DIALOGUE,true)
	run_sound(%DialogAudioStreamPlayer,true)

func end_dialogue(resource: DialogueResource):
	$DialogAudioStreamPlayer.stop()
#endregion


#region Music Methods
func play_music(trackID: String, pitchOverride: bool= false, loop:bool = true, fade:bool = false) -> void:
	var track: AudioStream = res.get_track(trackID)
	if track == null:
		return
	track.loop = loop
	%MusicAudioStreamPlayer.stream = track
	if res.pitchVariance and not pitchOverride:
		%MusicAudioStreamPlayer.pitch_scale = randf_range(res.pitchRange.x,res.pitchRange.y)
	%MusicAudioStreamPlayer.play()

func pause_music() -> void:
	if not %MusicAudioStreamPlayer.stream_paused:
		%MusicAudioStreamPlayer.stream_paused = true

func resume_music() -> void:
	if %MusicAudioStreamPlayer.stream_paused:
		%MusicAudioStreamPlayer.stream_paused = false

func stop_music() -> void:
	if %MusicAudioStreamPlayer.playing:
		%MusicAudioStreamPlayer.stop()

func change_music(trackID: String, loop:bool = true) -> void:
	var track: AudioStream = res.get_track(trackID)
	if track == null:
		return
	track.loop = loop
	%MusicAudioStreamPlayer.stream = track
	%MusicAudioStreamPlayer.play()
#endregion



"""
--- Bus and Effect Methods
"""
#region Audio Bus Methods
# Creates a bus and reroutes its output to specified bus
# Created bus is appended as last bus
func create_bus(sendBus: AudioManagerResource.busses) -> void:
	AudioServer.add_bus(AudioServer.bus_count)
	AudioServer.set_bus_send(AudioServer.bus_count, AudioServer.get_bus_name(sendBus))

# Deletes a specified bus
# If bus index is not specified it deletes the last bus
func delete_bus(busIndex:int = -1) -> void:
	if busIndex == -1:
		AudioServer.remove_bus(AudioServer.bus_count-1)
	else:
		AudioServer.remove_bus(busIndex)

func get_bus_enum(busName: String) -> AudioManagerResource.busses:
	return res.busses.get(busName.to_upper())

# Returns bus volume as linear transformation float (converts from db scale)
# If linearOutput is set to false; returns volume as db scale
func get_bus_volume(bus: AudioManagerResource.busses, linearOutput:bool = true) -> float:
	if linearOutput:
		return db_to_linear(AudioServer.get_bus_volume_db(bus))
	return AudioServer.get_bus_volume_db(bus)

# Sets bus volume from linear float (converts into db scale)
# If linearInput is set to false; set volume as db scale (doesn't convert)
func set_bus_volume(bus: AudioManagerResource.busses, x:float, linearInput:bool = true) -> void:
	if linearInput:
		AudioServer.set_bus_volume_db(bus, linear_to_db(x))
	else:
		AudioServer.set_bus_volume_db(bus, x)

# Resets bus volume to 0 db
func reset_bus_volume(bus: AudioManagerResource.busses) -> void:
	set_bus_volume(bus, 0.0)

# Resets all busses volume to 0 db
func reset_all_bus_volume(bus: AudioManagerResource.busses) -> void:
	for i in range(AudioServer.bus_count):
		set_bus_volume(i, 0.0)

# Mutes specified bus
func mute_bus_volume(bus: AudioManagerResource.busses) -> void:
	if AudioServer.is_bus_mute(bus):
		AudioServer.set_bus_mute(bus, false)

# Unmutes specified bus
func unmute_bus_volume(bus: AudioManagerResource.busses) -> void:
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
#endregion


#region Effects Methods
# Adds an effect to a specified bus to a specified index
# The effect has to create beforehand
# If index is not given it automatically appends it
func add_bus_effect(bus: AudioManagerResource.busses, effect:AudioEffect, index:int = -1) -> void:
	if index == -1:
		AudioServer.add_bus_effect(bus,effect,AudioServer.get_bus_effect_count(bus))
	else:
		AudioServer.add_bus_effect(bus,effect,index)

# Removes an effect from a specified bus on a specified index
# If index is not given it defaults into the last effect
func remove_bus_effect(bus: AudioManagerResource.busses, index:int = -1) -> void:
	if not check_bus_effect(bus, index):
		return
	
	if index == -1:
		AudioServer.remove_bus_effect(bus,AudioServer.get_bus_effect_count(bus)-1)
	else:
		AudioServer.remove_bus_effect(bus,index)

# Exchanges a bus effect for another one
# If index is not given it defaults into the last effect
func change_bus_effect(bus: AudioManagerResource.busses, effect:AudioEffect, index:int = -1) -> void:
	if not check_bus_effect(bus, index):
		return
	
	remove_bus_effect(bus, index)
	add_bus_effect(bus, effect, index)

# Clears all effects on a bus
func clear_bus_effect_all(bus: AudioManagerResource.busses) -> void:
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
#endregion



"""
--- Signal Methods
"""
#region Audio Manager Node Methods
func _on_dialog_audio_stream_player_finished() -> void:
	res.dialogueFinished = true
#endregion
