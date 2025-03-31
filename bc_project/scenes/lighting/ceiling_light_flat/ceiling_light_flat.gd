extends Light

func __local_ready() -> void:
	if lightColor:
		%PointLight2D.color = lightColor
	if lightEnergy:
		%PointLight2D.energy = lightEnergy

func set_state(circuitSignal: int, state: bool) -> void:
	if circuit == circuitSignal:
		%PointLight2D.enabled = state

func toggle_state(circuitSignal: int) -> void:
	if circuit == circuitSignal:
		%PointLight2D.enabled = not %PointLight2D.enabled
