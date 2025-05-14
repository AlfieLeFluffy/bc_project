class_name AreaTriggerShowHint extends AreaTrigger

@export var hint: CanvasLayer

const HINT_FADE_TIME: float = 1.0

#region Runtime Methods
func _colision_enter_player(player: Player) -> void:
	if hint:
		hint.visible = true
		if hint.get_child_count() > 0:
			if not hint.get_child(0) is Control:
				return
			var control: Control = hint.get_child(0)
			control.modulate = Color.TRANSPARENT
			GameController.fade_to_color(control, Color.WHITE, HINT_FADE_TIME)
	pass

func _colision_enter_npc(npc: NPC) -> void:
	pass


func _colision_exit_player(player: Player) -> void:
	if hint:
		if hint.get_child_count() > 0:
			if not hint.get_child(0) is Control:
				return
			var control: Control = hint.get_child(0)
			await GameController.fade_to_color(control, Color.TRANSPARENT, HINT_FADE_TIME)
		hint.visible = false
			
	pass

func _colision_exit_npc(npc: NPC) -> void:
	pass
#endregion
