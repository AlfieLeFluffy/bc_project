extends Node

#region Constants
const preloadTaskOverlay = preload("res://scenes/UI/overlay/task_overlay.tscn")
const preloadJournalMenu = preload("res://scenes/UI/journal/journal_menu.tscn")
#endregion

#region Variables
@export var res: TaskLevelResource

var overlay: TaskOverlay
var journal: JournalMenu
#endregion

#region Signals
## Signal for notifying scripts that a new task was loaded.
signal s_TasksLoaded()
## Signal for notifying scripts that a task was activated.
signal s_TaskActiavted()


## Signal for notifying [TaskController] to move the current tasks step forward.[br]
##
## - [param next] specifies which next step should be taken. 
##	If left blank then the first step in the next array will be taken. 
##	If no next step is pressent in the next array then the task completion script is run.[br]
signal s_CurrentNextStep(next: String)
## Signal for notifying [TaskController] to move the specified tasks step forward.[br]
##
## - [param task] specifies which task should be worked with. 
##	If left blank then the call fails.[br]
## - [param next] specifies which next step should be taken. 
##	If left blank then the first step in the next array will be taken. 
##	If no next step is pressent in the next array then the task completion script is run.[br]
signal s_NextStep(task: String, next: String)


## Signal for notifying [TaskController] to move the current tasks step to a specified next step.[br]
##
## - [param next] specifies which next step should be taken. 
##	If left blank then the call fails.
##	If next step is not present in the task step array then the call fails.[br]
signal s_CurrentGoToStep(next: String)
## Signal for notifying [TaskController] to move the specified tasks step to a specified next step.[br]
##
## - [param task] specifies which task should be worked with. 
##	If left blank then the call fails.[br]
## - [param next] specifies which next step should be taken. 
##	If left blank then the call fails.
##	If next step is not present in the task step array then the call fails.[br]
signal s_GoToStep(task: String, next: String)


## Signal for notifying [TaskController] to change the current task to a specified task.[br]
##
## - [param task] specifies which task should be worked with. 
##	If left blank then the call fails.[br]
signal s_ChangeTask(task: String)
## Signal for notifying [TaskController] to complete a task with specified status.[br]
##
## - [param task] specifies which task should be worked with. 
##	If left blank then the call fails.[br]
## - [param failed] specifies if the task was completed succesfully or failed.[br]
signal s_CompleteTask(task: String, failed: bool)
## Signal for notifying [TaskController] to change the statues of a task.[br]
##
## - [param task] specifies which task should be worked with. 
##	If left blank then the call fails.[br]
signal s_TaskChangeStatus(task: String)
#endregion


"""
--- Setup Methods
"""
#region Setup Methods
func _ready() -> void:
	self.add_to_group("Persistent")
	
	setup_task_overlay()
	setup_journal_menu()
	
	PersistenceController.s_SceneLoaded.connect(setup_task_overlay)
	PersistenceController.s_SceneLoaded.connect(setup_journal_menu)
	PersistenceController.s_SceneLoaded.connect(import_level_tasks)
	
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
	if GameController.detectiveBoard.visible:
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
#endregion



"""
--- Runtime Methods
"""
#region Task Managment Methods
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
#endregion



#region Step Managment Methods
func current_next_step(stepName: String = "") -> void:
	next_step(res.currentTask.name, stepName)

func next_step(taskName: String,stepName: String = "") -> void:
	if not res.tasksDict.has(taskName):
		return
	
	var task: TaskResource = res.tasksDict[taskName]
	var previousStep: TaskStepResource = task.currentStep
	
	if task.next_step(stepName):
		task.currentStep.run_commands(self)
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
		task.currentStep.run_commands(self)
		overlay.s_QueueUpdateStep.emit(task, previousStep,task.currentStep,false)
	else:
		check_ending(task)
#endregion



#region Task Completion Methods
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
#endregion



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
