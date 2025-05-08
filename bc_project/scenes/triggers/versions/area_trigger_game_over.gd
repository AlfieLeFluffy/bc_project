class_name AreaTriggerGameOver extends AreaTrigger

@export var gameOverType: GameOverResource.e_GameOverType 

#region Runtime Method Override
func _colision_enter_player(player: Player) -> void:
	if gameOverType:
		GameController.s_GameOver.emit(gameOverType)
	else:
		GameController.s_GameOver.emit(GameOverResource.e_GameOverType.CLIPPED)

func _colision_enter_npc(npc: NPC) -> void:
	pass


func _colision_exit_player(player: Player) -> void:
	pass

func _colision_exit_npc(npc: NPC) -> void:
	pass
#endregion
