class_name DialogueProfileResource extends Resource

@export var characterName: String = ""

@export var neutralProfile: Texture2D
@export var happyProfile: Texture2D
@export var sadProfile: Texture2D
@export var angryProfile: Texture2D

var emotionalDictionary: Dictionary = {
	"neutral": get_neutral_profile,
	"happy": get_happy_profile,
	"sad": get_sad_profile,
	"angry": get_angry_profile,
}

func get_neutral_profile() -> Texture2D:
	return neutralProfile

func get_happy_profile() -> Texture2D:
	return happyProfile

func get_sad_profile() -> Texture2D:
	return sadProfile

func get_angry_profile() -> Texture2D:
	return angryProfile

func get_texture(emotion: String = "neutral") -> Texture2D:
	if not emotionalDictionary.has(emotion):
		return emotionalDictionary["neutral"].call()
	return emotionalDictionary[emotion].call()
