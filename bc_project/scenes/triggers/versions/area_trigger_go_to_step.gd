class_name AreaTriggerGoToStep extends AreaTrigger

@export var taskName: String = ""
@export var stepName: String = ""

#region Runtime Methods
func _colision_enter_player(player: Player) -> void:
	if taskName != "":
		TaskController.s_GoToStep.emit(taskName,stepName)

func _colision_enter_npc(npc: NPC) -> void:
	pass


func _colision_exit_player(player: Player) -> void:
	pass

func _colision_exit_npc(npc: NPC) -> void:
	pass
#endregion
