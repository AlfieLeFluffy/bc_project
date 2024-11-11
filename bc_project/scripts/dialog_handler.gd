extends Node

@onready var parent: Node = get_parent()

func dialog_start() -> void:
	if parent.dialogs.size() > 0:
		DialogScripts.start_dialog(parent.dialogs[parent.dialogIndex],parent.heads[parent.headIndex])

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
	if parent.headIndex + 1 >= parent.heads.size() and not overflowFlag:
		parent.headIndex = 0
	else:
		parent.headIndex = parent.headIndex + 1

func set_head_index(index:int) -> void:
	parent.headIndex = index

func append_head_name(headName:String) -> void:
	parent.heads.append(headName)
