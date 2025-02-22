extends Node2D
	
func set_state(state: bool) -> void:
	$PointLight2D.enabled = state

func toggle_state() -> void:
	$PointLight2D.enabled = not $PointLight2D.enabled
