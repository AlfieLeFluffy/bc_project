extends Light
	
func set_state(circutSignal: int, state: bool) -> void:
	if circut == circutSignal:
		$PointLight2D.enabled = state

func toggle_state(circutSignal: int) -> void:
	if circut == circutSignal:
		$PointLight2D.enabled = not $PointLight2D.enabled
