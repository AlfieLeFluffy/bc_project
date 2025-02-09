extends Control

@export_group("Character Names")
@export var characterLeftName: String = Global.MainCharacterName
@export var characterRightName: String

@export_group("Fade/Talking Colors")
@export var fadedModulateColor: Color = Color("ffffff80")
@export var talkingModulateColor: Color = Color("ffffffff")
@export var baseProfileHeight: float
@export var offsetTalking: float

"""
--- Setup functions
"""

func _ready() -> void:
	baseProfileHeight = $CharacterLeft.position.y
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
			$CharacterLeft.position.y = baseProfileHeight
			$CharacterRight.position.y = baseProfileHeight + offsetTalking
			
			$CharacterLeft.modulate = talkingModulateColor
			$CharacterRight.modulate = fadedModulateColor
		characterRightName:
			$CharacterLeft.position.y = baseProfileHeight + offsetTalking
			$CharacterRight.position.y = baseProfileHeight
			
			$CharacterLeft.modulate = fadedModulateColor
			$CharacterRight.modulate = talkingModulateColor
		_:
			$CharacterLeft.position.y = baseProfileHeight
			$CharacterRight.position.y = baseProfileHeight
			
			$CharacterLeft.modulate = fadedModulateColor
			$CharacterRight.modulate = fadedModulateColor
