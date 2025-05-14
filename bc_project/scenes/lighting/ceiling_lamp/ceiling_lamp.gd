extends Light

func _local_ready() -> void:
	set_state(circuit,initialState)
	
func set_state(circuitSignal: int, state: bool) -> void:
	if circuit == circuitSignal:
		%SoftLight.enabled = state
		%HardLight.enabled = state

func toggle_state(circuitSignal: int) -> void:
	if circuit == circuitSignal:
		%SoftLight.enabled = not %SoftLight.enabled
		%HardLight.enabled = not %HardLight.enabled
