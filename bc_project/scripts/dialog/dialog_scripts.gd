extends Node

const Balloon = preload("res://scripts/dialog/balloon/balloon.tscn")

func start_dialog(filepath, title) -> void:
	var balloon: Node = Balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(filepath,title)
