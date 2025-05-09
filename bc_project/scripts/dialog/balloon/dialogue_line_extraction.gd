class_name DialogueLineExtraction extends Node

var currentLine: DialogueLine

func _ready() -> void:
	DialogueManager.got_dialogue.connect(set_current_line)

func set_current_line(line: DialogueLine) -> void:
	currentLine = line

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("add_to_board") and currentLine:
		var elementResource: ElementResource = ElementResource.new()
		var elementName: String = "narrator-"+currentLine.id
		if not currentLine.character.is_empty():
			elementName = currentLine.character+"-"+currentLine.id
		elementResource.setup(ElementResource.elementType.DIALOGUE,elementName,Global.currentTimeline.resource.name,currentLine.text,null)
		Signals.s_CreateBoardElement.emit(elementResource)
