class_name TaskOverlay extends Control

const TEXT_FORMAT_HEADER: String = "[font_size=%s][color=#%s]%s"
const TEXT_FORMAT: String = "[font_size=%s][color=#%s]%s"

@export_category("Font Sizes")
@export var headerFontSize: int = 18
@export var taskFontSize: int = 26
@export var stepFontSize: int = 22

signal s_NextUpdate()

signal s_QueueUpdateTask(task, step, failed)
signal s_QueueUpdateStep(task, previousStep, step, failed)

@export_range(0.0,20.0,0.1) var fadeTimeout: float = 4.0
@export_range(0.0,5.0,0.1) var lineTimeout: float = 0.5

var active: bool = false
var queue: Array[QueueItem]

func _ready() -> void:
	
	s_QueueUpdateTask.connect(queue_task_update)
	s_QueueUpdateStep.connect(queue_step_update)
	s_NextUpdate.connect(update)

func queue_task_update(task: TaskResource, step: TaskStepResource, failed: bool) -> void:
	queue.append(QueueTask.new(task, step, failed))
	
	if not active:
		s_NextUpdate.emit()

func queue_step_update(task: TaskResource, previousStep: TaskStepResource, step: TaskStepResource, failed: bool) -> void:
	queue.append(QueueStep.new(task, previousStep, step, failed))
	
	if not active:
		s_NextUpdate.emit()

func update() -> void:
	if queue.is_empty():
		return
	
	active = true
	
	var item: QueueItem = queue.pop_front()
	
	if item is QueueTask:
		await show_task_update(item)
	elif item is QueueStep:
		await show_step_update(item)
	
	active = false
	s_NextUpdate.emit()

func show_line(node: RichTextLabel, string: String, color: Color) -> bool:
	node.clear()
	node.parse_bbcode(string)
	await GameController.fade_to_color(node.get_parent().get_parent(),color)
	return true

func hide_line(node: RichTextLabel) -> bool:
	if node.get_parent().get_parent().modulate != Color.TRANSPARENT:
		await GameController.fade_to_color(node.get_parent().get_parent(),Color.TRANSPARENT)
	node.clear()
	return true

func show_header(item: QueueItem, color: Color = Color.WHITE) -> bool:
	await show_line(%TaskHeaderLabel,TEXT_FORMAT_HEADER % [str(headerFontSize),Global.color_TextHighlight.to_html(),tr(item.get_header())],color)
	await show_line(%TaskNameLabel,TEXT_FORMAT % [str(taskFontSize),Global.color_TextBright.to_html(),tr(item.get_task_name())],color)
	return true

func hide_all() -> bool:
	
	await hide_line(%TaskStepLabel)
	await hide_line(%TaskPreviousStepLabel)
	await hide_line(%TaskNameLabel)
	await hide_line(%TaskHeaderLabel)
	
	return true

func show_task_update(item: QueueTask) -> bool:
	var color: Color = Color.WHITE
	await show_header(item)
	await show_line(%TaskStepLabel,TEXT_FORMAT % [str(stepFontSize),Global.color_TextBright.to_html(),tr(item.get_step_name())],color)
	
	if item.complete:
		color = item.get_color()
		await GameController.fade_to_color(%TaskStepLabel,color)
		await GameController.fade_to_color(%TaskNameLabel,color)
		await GameController.fade_to_color(%TaskHeaderLabel,color)
	
	await get_tree().create_timer(fadeTimeout).timeout
	
	await hide_all()
	
	return true

func show_step_update(item: QueueStep) -> bool:
	var color: Color = Color.WHITE
	await show_header(item)
	await show_line(%TaskPreviousStepLabel,TEXT_FORMAT % [str(stepFontSize),Global.color_TextBright.to_html(),tr(item.get_previous_step_name())],color)
	
	if item.complete:
		color = item.get_color()
		await GameController.fade_to_color(%TaskPreviousStepLabel,color)
		await get_tree().create_timer(0.5).timeout
		color = Color.WHITE
		await show_line(%TaskStepLabel,TEXT_FORMAT % [str(stepFontSize),Global.color_TextBright.to_html(),tr(item.get_step_name())],color)
		
	
	await get_tree().create_timer(fadeTimeout).timeout
	
	await hide_all()
	
	return true

func overlay_fade_out_timeout() -> void:
	if not is_inside_tree():
		return
	await get_tree().create_timer(fadeTimeout).timeout
	
	if not is_inside_tree():
		return
	GameController.fade_to_color(self, Color("#ffffff00"))

class QueueItem:
	var task: TaskResource
	var step: TaskStepResource
	var complete: bool = false
	var failed: bool = false
	
	func _init(_task: TaskResource, _step: TaskStepResource, _failed: bool = false) -> void:
		task = _task
		step = _step
		if task:
			complete = task.finished
		failed = _failed
	
	func get_header() -> String:
		return "null"
	
	func get_task_name() -> String:
		if task:
			return task.name
		return ""
	
	func get_step_name() -> String:
		if step:
			return step.name
		return ""
	
	func get_color() -> Color:
		var output: Color = Color.WEB_GREEN
		if failed:
			output = Color.DARK_RED
		return output

class QueueTask extends QueueItem:
	
	func get_header() -> String:
		var header: String = "TASK_OVERLAY_LABEL"
		if complete and not failed:
			header = "TASK_OVERLAY_COMPLETE_LABEL"
		elif complete and failed:
			header = "TASK_OVERLAY_FAILED_LABEL"
		return header

class QueueStep extends QueueItem:
	var previousStep: TaskStepResource
	
	func _init(_task: TaskResource, _previousStep: TaskStepResource, _step: TaskStepResource, _failed: bool = false) -> void:
		task = _task
		previousStep = _previousStep
		step = _step
		if task:
			complete = true
		failed = _failed
	
	func get_header() -> String:
		var header: String = "STEP_OVERLAY_LABEL"
		if complete and not failed:
			header = "STEP_OVERLAY_COMPLETE_LABEL"
		elif complete and failed:
			header = "STEP_OVERLAY_FAILED_LABEL"
		return header
	
	func get_previous_step_name() -> String:
		if previousStep:
			return previousStep.name
		return ""
