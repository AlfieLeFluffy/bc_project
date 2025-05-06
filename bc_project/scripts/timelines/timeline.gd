class_name Timeline extends Node2D

## Resource used for the timeline instance
@export var resource: TimelineResource

## A method that sets the active status of this timeline and updates processes
## of child nodes to the active state. [br]
##
## - [param state] is a [bool] variable used to set the active status.
func set_active(state: bool) -> void:
	resource.active = state
	update_process()

## A method that updates the process status of all child nodes to the current
## active status.
func update_process() -> void:
	for node in get_children():
		node.set_process(resource.active)
