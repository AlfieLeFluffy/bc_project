class_name LevelController extends Node

"""
--- Level/Case Variables
"""
@export var clues: CluesLevelResource
@export var tasks: TaskLevelResource

"""
--- Setup functions
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PersistenceController.s_SceneLoaded.emit()

func _input(event: InputEvent) -> void:
	pass
