extends Node

const preloadTaskOverlay = preload("res://scenes/UI/overlay/task_overlay.tscn")
const preloadJournalMenu = preload("res://scenes/UI/journal/journal_menu.tscn")

@export var res: TaskLevelResource

var overlay: TaskOverlay
var journal: JournalMenu

signal s_TasksLoaded()
signal s_TaskActiavted()

signal s_CurrentNextStep(next)
signal s_NextStep(task,next)

signal s_CurrentGoToStep(next)
signal s_GoToStep(task,next)

signal s_ChangeTask(task)
signal s_CompleteTask(task, failed)
signal s_TaskChangeStatus(task)

func _ready() -> void:
	self.add_to_group("Persistent")
	
	setup_task_overlay()
	setup_journal_menu()
	
	GameController.sceneLoaded.connect(setup_task_overlay)
	GameController.sceneLoaded.connect(setup_journal_menu)
	GameController.sceneLoaded.connect(import_level_tasks)
	
	s_CurrentNextStep.connect(current_next_step)
	s_NextStep.connect(next_step)
	
	s_CurrentGoToStep.connect(current_go_to_step)
	s_GoToStep.connect(go_to_step)
	
	s_CompleteTask.connect(complete_task)
	

func setup_task_overlay() -> void:
	# Checks if the scene name is in the nongameplay scenes
	# If the scene is a non gameplay one this menu cannot open
	if GameController.check_nongameplay_scene():
		return
	overlay = preloadTaskOverlay.instantiate()
	if GameController.mainOverlay:
		GameController.mainOverlay.add_child(overlay)
	

func setup_journal_menu() -> void:
	# Checks if the scene name is in the nongameplay scenes
	# If the scene is a non gameplay one this menu cannot open
	if GameController.check_nongameplay_scene():
		return
	journal = preloadJournalMenu.instantiate()
	if GameController.mainOverlay:
		GameController.mainOverlay.add_child(journal)

func import_level_tasks() -> void:
	if overlay:
		overlay.queue.clear()
	var scene: Node = get_tree().current_scene
	if scene is LevelController:
		var level: LevelController = scene
		if level.tasks:
			level.tasks.reset_state()
			setup_level_tasks(level.tasks)
	else:
		if res:
			res = null
	
	s_TasksLoaded.emit()

func setup_level_tasks(_resource: TaskLevelResource) -> void:
	res = _resource
	res.setup()
	if res.initialTask and not res.currentTask:
		res.currentTask = res.initialTask
		set_task_active(res.currentTask)

func set_task_active(task: TaskResource) -> void:
	if res.activeTasks.has(task.name):
		return
	task.setup()
	res.activeTasks.set(task.name, task)
	s_TaskActiavted.emit()
	if overlay:
		overlay.s_QueueUpdateTask.emit(res.currentTask,res.currentTask.currentStep,false)

func set_task_active_name(taskName: String) -> void:
	if not res.tasksDict.has(taskName):
		return
	set_task_active(res.tasksDict[taskName])
	
func set_task_complete(task: TaskResource, failed: bool = false) -> void:
	task.finished = true
	task.failed = failed
	task.emit_changed()

func current_next_step(stepName: String = "") -> void:
	next_step(res.currentTask.name, stepName)

func next_step(taskName: String,stepName: String = "") -> void:
	if not res.tasksDict.has(taskName):
		return
	
	var task: TaskResource = res.tasksDict[taskName]
	var previousStep: TaskStepResource = task.currentStep
	
	if task.next_step(stepName):
		task.currentStep.run_command(self)
		overlay.s_QueueUpdateStep.emit(task, previousStep,task.currentStep,false)
	else:
		check_ending(task)

func current_go_to_step(stepName: String = "") -> void:
	go_to_step(res.currentTask.name, stepName)

func go_to_step(taskName: String,stepName: String = "") -> void:
	if not res.tasksDict.has(taskName):
		return
	
	var task: TaskResource = res.tasksDict[taskName]
	var previousStep: TaskStepResource = task.currentStep
	
	if task.go_to_step(stepName):
		task.currentStep.run_command(self)
		overlay.s_QueueUpdateStep.emit(task, previousStep,task.currentStep,false)
	else:
		check_ending(task)

func check_ending(task: TaskResource) -> bool:
	if task.currentStep.next:
		if task.currentStep.next.size() > 0:
			return false
	else:
		complete_task(task.name, task.endSteps.find(task.currentStep) < 0)
	return true

func complete_task(taskName: String, failed: bool = false) -> void:
	if not res.tasksDict.has(taskName):
		return
	
	var task: TaskResource = res.tasksDict[taskName]
	var previousStep: TaskStepResource = task.currentStep
	
	set_task_complete(task,failed)
	s_TaskChangeStatus.emit(task)
	
	if overlay:
		overlay.s_QueueUpdateTask.emit(task,previousStep,task.failed)

#region Persistence Methods
"""
--- Persistence Methods 
"""
func saving() -> Dictionary:
	var output: Dictionary = {
		"persistent": true,
		"nodepath": get_path(),
		"parent": get_parent().get_path(),
		"resources": {
			"resource": res,
		},
	}
	return output

func loading(input: Dictionary) -> bool:
	if input.has("resources"):
		if input["resources"].has("resource"):
			setup_level_tasks(input["resources"]["resource"])
	return true
#endregion
