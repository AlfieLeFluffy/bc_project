extends Light

func _local_ready() -> void:
	set_state(circuit,initialState)
	
func set_state(circuitSignal: int, state: bool) -> void:
	if circuit == circuitSignal:
		$PointLight2D.enabled = state

func toggle_state(circuitSignal: int) -> void:
	if circuit == circuitSignal:
		$PointLight2D.enabled = not $PointLight2D.enabled
