class_name ElevatorMenuButton extends Button

var id: String = ""
var key: String = ""

func setup_button(_id: String,_key: String):
	id = _id
	key = _key
	text = key

func _on_pressed() -> void:
	Signals.emit_signal("elevator_move_to_key",id,key)
