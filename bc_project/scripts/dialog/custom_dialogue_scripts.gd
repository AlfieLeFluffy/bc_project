class_name DialogueScripts extends Node

#region Setup Methods
func _ready() -> void:
	pass
#endregion

#region Runtime Methods
func start_dialogue(dialogueResource: DialogueResource) -> void:
	if not dialogueResource:
		printerr("Error: Cannot play empty dialogue resource")
	DialogueManager.show_dialogue_balloon(dialogueResource,dialogueResource.first_title)
#endregion
