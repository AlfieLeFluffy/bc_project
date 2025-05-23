extends Control

@export_group("Main Character")
@export var mainCharacterName: String = Global.PLAYER_CHARACTER_NAME

@export_group("Character Profiles")
@export var characterProfilesArray: Array[DialogueProfileResource]
var characterProfilesDictionary: Dictionary

@export_group("Fade and Talking Colors")
@export var fadedModulateColor: Color = Color("ffffff80")
@export var talkingModulateColor: Color = Color("ffffffff")
@export var offsetTalking: float
var baseProfileHeight: float

var left: bool = false
var right: bool = false
var talkingTweenOffset: Vector2 = Vector2(0.0,10.0)
var talkingTweenTime: float = 3.0
var tween: Tween

"""
--- Setup functions
"""

func _ready() -> void:
	baseProfileHeight = (%CharacterProfileLeft.position.y +  %CharacterProfileRight.position.y) / 2
	
	setup_profile_dictionary()
	
	DialogueManager.got_dialogue.connect(toggle_profiles)
	
	%DialogueLabel.spoke.connect(animate_talking)

func setup_profile_dictionary() -> void:
	for profile in characterProfilesArray:
		characterProfilesDictionary[profile.characterName] = profile

func setup_main_character() -> void:
	if characterProfilesDictionary.has(mainCharacterName):
		%CharacterProfileLeft.texture = characterProfilesDictionary[mainCharacterName].get_texture()

func animate_talking(letter: String, letter_index: int, speed: float) -> void:
	pass

func toggle_profiles(line: DialogueLine) -> void:
	if %CharacterProfileLeft.texture == null:
		setup_main_character()
	%CharacterProfileLeft.position.y = baseProfileHeight
	%CharacterProfileRight.position.y = baseProfileHeight
	
	var emotion: String = "neutral"
	if line.get_tag_value("mood"):
		emotion = line.get_tag_value("mood")
	
	if line.character == mainCharacterName:
		left = true
		right = false
		%CharacterProfileLeft.texture = characterProfilesDictionary[mainCharacterName].get_texture(emotion)
		update_profiles()
	elif characterProfilesDictionary.has(line.character):
		%CharacterProfileRight.texture = characterProfilesDictionary[line.character].get_texture(emotion)
		left = false
		right = true
		update_profiles()
	else:
		left = false
		right = false
		update_profiles()

func update_profiles() -> void:
	if tween:
		if tween.is_running():
			tween.stop()
		tween.kill()
	%CharacterProfileLeft.position.y = baseProfileHeight
	%CharacterProfileRight.position.y = baseProfileHeight
	if left:
		%CharacterProfileLeft.position.y = baseProfileHeight - offsetTalking
		tween = create_tween().set_loops()
		tween.tween_property(%CharacterProfileLeft, "position", %CharacterProfileLeft.position+talkingTweenOffset, talkingTweenTime)
		tween.tween_property(%CharacterProfileLeft, "position", %CharacterProfileLeft.position-talkingTweenOffset, talkingTweenTime)
	elif right:
		%CharacterProfileRight.position.y = baseProfileHeight - offsetTalking
		tween = create_tween().set_loops()
		tween.tween_property(%CharacterProfileRight, "position", %CharacterProfileRight.position+talkingTweenOffset, talkingTweenTime)
		tween.tween_property(%CharacterProfileRight, "position", %CharacterProfileRight.position-talkingTweenOffset, talkingTweenTime)
	
	%CharacterFadeLeft.visible = left
	%CharacterFadeRight.visible = right
	%CharacterProfileLeft.modulate = fadedModulateColor
	%CharacterProfileRight.modulate = fadedModulateColor
	if left:
		%CharacterProfileLeft.modulate = talkingModulateColor
	elif right:
		%CharacterProfileRight.modulate = talkingModulateColor
	
