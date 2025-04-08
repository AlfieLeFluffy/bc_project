class_name AreaTriggerDialogue extends AreaTrigger

@export var dialogueResource: DialogueResource

#region Runtime Method Override
func _colision_enter_player(player: Player) -> void:
	CustomDialogueScripts.start_dialogue(dialogueResource,"",null)

func _colision_enter_npc(npc: NPC) -> void:
	pass


func _colision_exit_player(player: Player) -> void:
	CustomDialogueScripts.start_dialogue(dialogueResource,"",null)

func _colision_exit_npc(npc: NPC) -> void:
	pass
#endregion
