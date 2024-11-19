class_name DialogHandler extends Node

@onready var parent: Node = get_parent()

@export_group("Dialog")
@export var dialog_resource: DialogResource

func dialog_start() -> void:
	if dialog_resource:
		DialogScripts.start_dialog(dialog_resource.dialog,dialog_resource.titleName)

"""
--- Dialog control functions
"""
