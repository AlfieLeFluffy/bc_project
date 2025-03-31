class_name ElevatorCallButton extends Interactable

#region Variables
@export var key: String = ""
@export var resource: ElevatorResource
var valid: bool = false
#endregion

#region Setup Methods
# Local ready function for instantiated objects
func _local_ready() -> void:
	if not is_instance_valid(resource):
		printerr("Error: Elevator call button missing resource, button key '%s'" % key)
		return
	if not resource.stops.has(key):
		printerr("Error: Elevator call button key doesn't exist in elevator resource stops, button key '%s' and elevator id '%s'" % [key, resource.id])
		return
	valid = true
#endregion

#region Runtime Methods
# Active function if no dialog detected
func _interact_function(event: InputEvent) -> void:
	if valid:
		Signals.elevator_move_to_key.emit(resource.id,key)
#endregion
