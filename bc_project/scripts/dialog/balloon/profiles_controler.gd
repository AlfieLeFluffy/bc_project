extends Control

@export_group("Character Names")
@export var characterLeftName: String = Global.MainCharacterName
@export var characterRightName: String

@export_group("Fade/Talking Colors")
@export var fadedModulateColor: Color = Color("ffffff80")
@export var talkingModulateColor: Color = Color("ffffffff")

"""
--- Setup functions
"""

func _ready() -> void:
	DialogueManager.connect("got_dialogue", toggle_profiles)
	Signals.connect("setup_conversation_profile",setup_character_right)


func setup_character_right(side, character_name, picture) -> void:
	match side:
		"left":
			characterLeftName = character_name
			$CharacterLeft.texture = picture
		"right":
			characterRightName = character_name
			$CharacterRight.texture = picture
		_:
			pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func toggle_profiles(line: DialogueLine) -> void:
	match line.character:
		characterLeftName:
			$CharacterLeft.modulate = talkingModulateColor
			$CharacterRight.modulate = fadedModulateColor
		characterRightName:
			$CharacterLeft.modulate = fadedModulateColor
			$CharacterRight.modulate = talkingModulateColor
		_:
			$CharacterLeft.modulate = fadedModulateColor
			$CharacterRight.modulate = fadedModulateColor
