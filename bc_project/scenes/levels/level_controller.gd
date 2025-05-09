class_name LevelController extends Node

#region Level Variables
## A variable that holds all level clues in a [CluesLevelResource]
@export var clues: CluesLevelResource
## A variable that holds all level tasks in a [TaskLevelResource]
@export var tasks: TaskLevelResource
#endregion

func _ready() -> void:
	PersistenceController.s_SceneLoaded.emit()
