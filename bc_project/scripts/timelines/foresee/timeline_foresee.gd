class_name TimelineForesee extends Node2D

@export var from: Timeline
@export var to: Timeline

func _ready() -> void:
	%SubViewport.world_2d = get_viewport().world_2d
	

func _physics_process(delta: float) -> void:
	global_position = get_global_mouse_position()
	move_camera(from,to)
	
func move_camera(start: Timeline, end: Timeline) -> void:
	var mousePosition: Vector2 = get_global_mouse_position()
	var timelinePosition: Vector2 = start.to_local(mousePosition)
	%ForeseeCamera.position = end.to_global(timelinePosition)
