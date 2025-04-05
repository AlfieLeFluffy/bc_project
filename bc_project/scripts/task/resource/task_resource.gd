class_name TaskResource extends Resource

@export var name: String

@export var finished: bool = false
@export var failed: bool = false

@export var currentStep: TaskStepResource
@export var steps: Array[TaskStepResource]
@export var endSteps: Array[TaskStepResource]
@export var stepsDict: Dictionary

func setup() -> void:
	if not currentStep:
		if steps:
			if not steps.is_empty():
				currentStep = steps.get(0)
	
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
		currentStep = currentStep.next.get(0)
		return true
	else:
		var nextStep: TaskStepResource = stepsDict.get(stepName)
		if not currentStep.next.has(nextStep):
			return false
		currentStep = nextStep
		return true

func go_to_step(stepName: String = "") -> bool:
	if not currentStep:
		return false
	
	if not stepsDict.has(stepName):
		return false
	
	var nextStep: TaskStepResource = stepsDict.get(stepName)
	currentStep = nextStep
	return true
