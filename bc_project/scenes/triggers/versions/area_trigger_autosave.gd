class_name AreaTriggerAutoSave extends AreaTrigger


#region Runtime Methods
func _colision_enter_player(player: Player) -> void:
	await get_tree().create_timer(0.1).timeout
	PersistenceController.autosaveGame.emit()

func _colision_enter_npc(npc: NPC) -> void:
	pass


func _colision_exit_player(player: Player) -> void:
	pass

func _colision_exit_npc(npc: NPC) -> void:
	pass
#endregion
