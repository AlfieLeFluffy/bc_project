class_name TaskResource extends Resource

@export var name: String

@export var finished: bool = false
@export var failed: bool = false

@export var currentStep: TaskStepResource
@export var steps: Array[TaskStepResource]
@export var history: Array[TaskStepResource]
@export var endSteps: Array[TaskStepResource]
@export var stepsDict: Dictionary

func setup() -> void:
	if not steps:
		return
	if steps.is_empty():
		return
	
	if not currentStep:
		currentStep = steps.get(0)
	
	history.append(currentStep)
	
	for step in steps:
		stepsDict.set(step.name, step)

func next_step(stepName: String = "") -> bool:
	if not currentStep:
		return false
	
	if stepName != "":
		if not stepsDict.has(stepName):
			return false
	
	if stepName == "":
		if currentStep.next.is_empty():
			return false
		change_current_step(currentStep.next.get(0))
		return true
	else:
		var nextStep: TaskStepResource = stepsDict.get(stepName)
		if not currentStep.next.has(nextStep):
			emit_changed()
			return false
		change_current_step(nextStep)
		return true

func go_to_step(stepName: String = "") -> bool:
	if not currentStep:
		return false
	
	if not stepsDict.has(stepName):
		return false
	
	var nextStep: TaskStepResource = stepsDict.get(stepName)
	change_current_step(nextStep)
	return true

func change_current_step(nextStep: TaskStepResource) -> void:
	history.append(nextStep)
	currentStep = nextStep
	emit_changed()

func get_color() -> Color:
	var output: Color = Global.color_TextHighlight
	if finished and not failed:
		output = Color.WEB_GREEN
	if finished and failed:
		output = Color.DARK_RED
	return output
