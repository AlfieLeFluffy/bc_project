class_name DialogHandler extends Node

@onready var parent: Node = get_parent()

@export_group("Dialog")
@export var dialogIndex: int = 0 
@export var dialogs: Array[DialogueResource]
@export var titleIndex: int = 0 
@export var titles: PackedStringArray

func dialog_start() -> void:
	if dialogs.size() > 0:
		DialogScripts.start_dialog(dialogs[dialogIndex],titles[titleIndex])

"""
--- Dialog control functions
"""

func increment_dialog_index(overflowFlag:bool = false) -> void:
	if dialogIndex + 1 >= dialogs.size() and not overflowFlag:
		dialogIndex = 0
	else:
		dialogIndex = dialogIndex + 1

func set_dialog_index(index:int) -> void:
	dialogIndex = index

func append_dialog_file(filepath:String) -> void:
	dialogs.append(filepath)

func increment_head_index(overflowFlag:bool = false) -> void:
	if titleIndex + 1 >= titles.size() and not overflowFlag:
		titleIndex = 0
	else:
		titleIndex = titleIndex + 1

func set_head_index(index:int) -> void:
	titleIndex = index

func append_head_name(headName:String) -> void:
	titles.append(headName)
