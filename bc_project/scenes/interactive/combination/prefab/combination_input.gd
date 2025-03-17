class_name CombinationInput extends VBoxContainer

var view: CombinationLockView
var array: Array[String] = ["0","1","2"]
var index: int = 0

#region Setup Methods
func _ready() -> void:
	#if not check_variables():
	#	return
	
	%Center.text = array[index]

func check_variables() -> bool:
	if not view:
		printerr("Error: Combination input doesn't have view assigned.")
		return false
	if not array:
		printerr("Error: Combination input of view %s doesn't have an array assigned." % view.name)
		return false
	return true
#endregion



#region Runtime Methods
func get_current_input() -> String:
	return array[index]

func move_index(direction) -> void:
	if index + direction > array.size()-1:
		index = 0
	elif index + direction < 0:
		index = array.size()-1
	else:
		index += direction
	%Center.text = array[index]
	
#endregion



#region Signal Methods
func _on_up_pressed() -> void:
	move_index(-1)

func _on_down_pressed() -> void:
	move_index(1)
#endregion
