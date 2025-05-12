class_name ElevatorCallButton extends Interactable

#region Variables
@export var elevatorID: String = ""
@export var stopID: String = ""
#endregion

#region Setup Methods
# Local ready function for instantiated objects
func _local_ready() -> void:
	pass
#endregion

#region Runtime Methods
# Active function if no dialog detected
func _interact_function(event: InputEvent) -> void:
	Signals.s_ElevatorMoveToKey.emit(elevatorID,stopID)
#endregion
