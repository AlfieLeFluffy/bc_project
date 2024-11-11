extends Node

@onready var parent: Node = get_parent()

func dialog_start() -> void:
	if parent.dialogs.size() > 0:
		DialogScripts.start_dialog(parent.dialogs[parent.dialogIndex],parent.titles[parent.titleIndex])

"""
--- Dialog control functions
"""

func increment_dialog_index(overflowFlag:bool = false) -> void:
	if parent.dialogIndex + 1 >= parent.dialogs.size() and not overflowFlag:
		parent.dialogIndex = 0
	else:
		parent.dialogIndex = parent.dialogIndex + 1

func set_dialog_index(index:int) -> void:
	parent.dialogIndex = index

func append_dialog_file(filepath:String) -> void:
	parent.dialogs.append(filepath)

func increment_head_index(overflowFlag:bool = false) -> void:
	if parent.titleIndex + 1 >= parent.titles.size() and not overflowFlag:
		parent.titleIndex = 0
	else:
		parent.titleIndex = parent.titleIndex + 1

func set_head_index(index:int) -> void:
	parent.titleIndex = index

func append_head_name(headName:String) -> void:
	parent.titles.append(headName)
