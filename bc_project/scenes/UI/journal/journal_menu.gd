class_name JournalMenu extends Control

const prelaodTaskEntry = preload("res://scenes/UI/journal/prefab/task_entry.tscn")

@export var res: TaskLevelResource

@export var entries: Dictionary

"""
--- Setup Methods
"""
#region Setup Methods

func _ready() -> void:
	visible = false
	
	TaskController.s_TasksLoaded.connect(setup_tasks)
	TaskController.s_TaskActiavted.connect(setup_tasks)
	TaskController.s_TaskChangeStatus.connect(change_task_status)
	
	Signals.input_help_set.emit(GameController.get_input_key_list("journal_toggle"), "JOURNAL_INPUT_HELP")


func setup_tasks() -> void:
	if not TaskController.res:
		return
	res = TaskController.res
	for task in res.activeTasks:
		if not entries.has(task):
			entries.set(task,null)
			setup_task.call_deferred(task)

func setup_task(taskName: String) -> void:
	var entry: TaskEntry = prelaodTaskEntry.instantiate()
	entry.task = res.tasksDict[taskName]
	entries.set(taskName,entry)
	if not entry.task.finished:
		%ActiveTaskList.add_child(entry)
	else:
		%FinishedTaskList.add_child(entry)
	
	update_task_labels()

#endregion



"""
--- Runtime Methods
"""
#region Input and Menu Managment Methods

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("journal_toggle"):
		toggle_menu()
	if visible and event.is_action_pressed("ui_menu"):
		toggle_menu()

func toggle_menu() -> void:
	visible = not visible

func update_task_labels() -> void:
	%ActiveTasksLabel.parse_bbcode("%s (%s)" % [tr("ACTIVE_TASK_LABEL"),%ActiveTaskList.get_child_count()])
	%FinishedTasksLabel.parse_bbcode("%s (%s)" % [tr("FINISHED_TASK_LABEL"),%FinishedTaskList.get_child_count()])
	

func change_task_status(task: TaskResource) -> void:
	if not entries.has(task.name):
		return
	var entry: TaskEntry = entries.get(task.name)
	if task.finished and %ActiveTaskList.get_node(NodePath(entry.name)) != null:
		%ActiveTaskList.remove_child(entry)
		%FinishedTaskList.add_child(entry)
		update_task_labels()


func setup_collapse_button(button: Button, control: Control) -> void:
	if control.visible:
		button.text = "CLOSE_BUTTON"
	else:
		button.text = "OPEN_BUTTON"

#endregion



#region Node Signal Methods

func _on_button_pressed() -> void:
	toggle_menu()

#endregion

func _on_active_collapse_button_pressed() -> void:
	%ActiveTaskList.visible = not %ActiveTaskList.visible
	setup_collapse_button(%ActiveCollapseButton, %ActiveTaskList)


func _on_finished_collapse_button_pressed() -> void:
	%FinishedTaskList.visible = not %FinishedTaskList.visible
	setup_collapse_button(%FinishedCollapseButton, %FinishedTaskList)
