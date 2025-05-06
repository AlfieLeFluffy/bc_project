class_name MainMenuCameraController extends Node2D

## Variable keeping last inputed mouse position  
@export_range(0.0,1.0,0.01) var ration: float = 0.03

## Variable keeping last inputed mouse position  
var mousePosition: Vector2

func _input(event: InputEvent) -> void:
	## If input event is [InputEventMouse], then it stores its local position 
	if event is InputEventMouse:
		mousePosition = get_local_mouse_position()

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	## Positions the camera controller between the center of the screen and the last know [param mousePosition][br]
	## This is weighted by the parameter [param ration] to keep the camera overall centered.
	position = Vector2(0.0,0.0).lerp(mousePosition, ration)
