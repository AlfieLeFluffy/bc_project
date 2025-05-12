class_name TalkingNpcState extends State

"""
--- Exported Physics Constants
"""
@export_group("Character Body Constants")
@export var SPEED: int = 60
@export var JUMP_VELOCITY: int = -200
@export var characterBody: CharacterBody2D

var talking: bool = false

"""
--- State Setup/Exit functions
"""

func _ready() -> void:
	DialogueManager.connect("dialogue_ended", end_conversation)

func Enter() -> void:
	talking = true

func Exit() -> void:
	pass

"""
--- State Runtime functions
"""

func Process(delta: float) -> void:
	pass

func Physics_Process(delta: float) -> void:
	if characterBody:
		characterBody.velocity = Vector2()
	
	if not talking:
		Transition.emit(self,"Wander")

"""
--- Conversation state functions
"""

func end_conversation(resource) -> void:
	if talking:
		talking = not talking
