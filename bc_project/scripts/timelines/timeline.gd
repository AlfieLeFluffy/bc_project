class_name Timeline extends Node2D

@export var resource: TimelineResource

func _ready() -> void:
	pass

func set_active(state: bool) -> void:
	resource.active = state
	setup_process()

func setup_process() -> void:
	for node in get_children():
		node.set_process(resource.active)
