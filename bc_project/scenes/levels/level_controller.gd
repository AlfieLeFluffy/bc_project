class_name LevelController extends Node2D

"""
--- Level/Case Variables
"""
@export var caseClues: ClueCombinaions
@export var dialogueVaribles: Dictionary

"""
--- Setup functions
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameController.sceneLoaded.emit()
	Signals.setup_level_dialogue_variables.emit(dialogueVaribles)

func _input(event: InputEvent) -> void:
	pass
