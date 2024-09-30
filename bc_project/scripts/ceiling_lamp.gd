extends Node2D

var pointLight

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pointLight = get_node("PointLight2D")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func toggleLight() -> void:
	if pointLight.visible:
		pointLight.visible = 0
	else:
		pointLight.visible = 1
