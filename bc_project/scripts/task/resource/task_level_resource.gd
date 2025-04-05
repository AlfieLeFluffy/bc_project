class_name TaskLevelResource extends Resource

## Holds a list of all [TaskResource] objects for a given level.
@export var tasks: Array[TaskResource] = []
@export var tasksDict: Dictionary
@export var activeTasks: Dictionary

## Initial task if any is given.
@export var initialTask: TaskResource

## Initial task if any is given.
@export var currentTask: TaskResource

## Returns a dictionary of [param tasks] objects of type [TaskResource] in a dictionary. [br]
## The key value is the [param name] of the [TaskResource].
func setup() -> void:
	tasksDict = get_task_dictionary()

## Returns a dictionary of [param tasks] objects of type [TaskResource] in a dictionary. [br]
## The key value is the [param name] of the [TaskResource].
func get_task_dictionary() -> Dictionary:
	var output: Dictionary = {}
	
	if not tasks:
		return output
	
	for task in tasks:
		if task is TaskResource:
			output.set(task.name,task)
	
	return output
