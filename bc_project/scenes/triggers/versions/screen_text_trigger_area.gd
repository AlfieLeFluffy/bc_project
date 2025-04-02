class_name AreaTriggerScreenText extends AreaTrigger

@export_multiline var ScreenTextString: String ## Use semicolons ',' for spliting of the text

#region Runtime Methods
func _colision_enter_player(player: Player) -> void:
	if ScreenTextString:
		GameController.play_screen_text_effect(ScreenTextString)

func _colision_enter_npc(npc: NPC) -> void:
	pass


func _colision_exit_player(player: Player) -> void:
	pass

func _colision_exit_npc(npc: NPC) -> void:
	pass
#endregion
