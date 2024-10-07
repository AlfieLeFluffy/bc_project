extends Node2D
	
func toggleLight() -> void:
	if $PointLight2D.visible:
		$PointLight2D.visible = 0
	else:
		$PointLight2D.visible = 1
