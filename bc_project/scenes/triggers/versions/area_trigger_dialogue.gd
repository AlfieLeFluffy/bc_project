class_name AreaTriggerDialogue extends AreaTrigger

@export var dialogResource: DialogResource

#region Runtime Method Override
func _colision_enter_player(player: Player) -> void:
	DialogScripts.start_dialog(dialogResource.dialog,dialogResource.titleName)

func _colision_enter_npc(npc: NPC) -> void:
	pass


func _colision_exit_player(player: Player) -> void:
	DialogScripts.start_dialog(dialogResource.dialog,dialogResource.titleName)

func _colision_exit_npc(npc: NPC) -> void:
	pass
#endregion
