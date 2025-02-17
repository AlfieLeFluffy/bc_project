class_name LevelController extends Node2D

"""
--- Level/Case Variables
"""
@export var caseClues: ClueCombinaions

"""
--- Setup functions
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.emit_signal("scene_loaded")
