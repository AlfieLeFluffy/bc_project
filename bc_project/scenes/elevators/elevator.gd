class_name Elevator extends Node2D

#region Veriables
@export var resource: ElevatorResource
#endregion

#region Setup Methods
func _ready():
	if resource.currentStop == "" and not resource.stops.is_empty():
		resource.currentStop = resource.stops.keys()[0]
	if resource.currentStop != "":
		%ElevatorCabin.position = resource.stops[resource.currentStop]
	
	Signals.connect("elevator_move_to_key",move_to_stop_key)
	Signals.connect("elevator_move_to_vector",move_to_stop_vector)
	
	if resource.currentStop and resource.movingToStop:
		var timeout: float = resource.startupTimeout
		resource.startupTimeout = 0.0
		move_to_stop(resource.movingToStop)
		resource.startupTimeout = resource.startupTimeout
	
	setup_cabin()
#endregion

#region Runtime Methods
func _unhandled_input(event: InputEvent) -> void:
	pass

func _physics_process(delta: float) -> void:
	if resource.active and resource.movementJitters:
		if randi_range(1,100-resource.movementJitterFrequency) <= 1:
			pass

#endregion

#region Incoming Signal Methods
func move_to_stop_key(id:String, key: String, force: bool = false) -> void:
	if not check_input_valid(id, key, force):
		return
	move_to_stop(key)

func move_to_stop_vector(id:String, vector: Vector2, force: bool = false) -> void:
	if not check_input_valid(id, vector, force):
		return
	move_to_vector(vector)
	
func check_input_valid(id: String, stop, force: bool = false) -> bool:
	if id != resource.id:
		return false
	
	if stop is String:
		if not resource.stops.has(stop):
			printerr("Error: Elevator stop of key '%s' does not exist in elevator id '%s'" % [stop, resource.id])
			return false
	elif stop is Vector2:
		if not is_instance_valid(stop):
			printerr("Error: Elevator move to vector needs a valid vector, elevator id '%s'" % resource.id)
			return false
	else:
		printerr("Error: Elevator move to vector needs a valid vector, elevator id '%s'" % resource.id)
		return false
	
	if resource.active and not force:
		printerr("Error: Elevator is active, cannot move to stop vector '%s' for elevator id '%s'" % [str(stop), resource.id])
		return false
	return true
#endregion

#region Elevator Managment Methods
func move_to_stop(key: String) -> void:
	resource.movingToStop = key
	await set_cabin(true)
	setup_tween(%ElevatorCabin.position, resource.stops[key])
	await run_tween()
	resource.currentStop = key
	await set_cabin(false)

func move_to_vector(vector: Vector2) -> void:
	resource.stops["vector"] = vector
	resource.movingToStop = "vector"
	await set_cabin(true)
	setup_tween(%ElevatorCabin.position, vector)
	await run_tween()
	resource.currentStop = "vector"
	await set_cabin(false)

func setup_cabin() -> void:
	%DoorLeftCollision.disabled = (resource.openning & resource.OPENNING_LEFT) and not resource.active
	%DoorsRightCollision.disabled = (resource.openning & resource.OPENNING_RIGHT) and not resource.active
	%LeftOccluder.visible = not (resource.openning & resource.OPENNING_LEFT)
	%RightOccluder.visible = not (resource.openning & resource.OPENNING_RIGHT)
	%LeftWallSprite.visible = not (resource.openning & resource.OPENNING_LEFT)
	%RightWallSprite.visible = not (resource.openning & resource.OPENNING_RIGHT)

func set_cabin(state: bool) -> bool:
	resource.set_active(state)
	if resource.startupTimeout:
		await get_tree().create_timer(resource.startupTimeoutDuration).timeout
	%DoorLeftCollision.disabled = (resource.openning & resource.OPENNING_LEFT) and not resource.active
	%DoorsRightCollision.disabled = (resource.openning & resource.OPENNING_RIGHT) and not resource.active
	%LeftOccluder.visible = resource.active or not (resource.openning & resource.OPENNING_LEFT)
	%RightOccluder.visible = resource.active or not (resource.openning & resource.OPENNING_RIGHT)
	return true

func setup_tween(start: Vector2, end: Vector2) -> void:
	var duration: float = culculate_duration(start.y,end.y)
	resource.tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	resource.tween.pause()
	resource.tween.set_loops(1).set_parallel(1)
	resource.tween.tween_property(%ElevatorCabin, "position", start, duration)
	resource.tween.tween_property(%ElevatorCabin, "position", end, duration)

func run_tween() -> bool:
	resource.tween.play()
	await resource.tween.finished
	resource.tween.kill()
	return true

func culculate_duration(x: float, y: float) -> float:
	return abs(x - y) / resource.speed
#endregion

#region Persistence Methods
func saving() -> Dictionary:
	return {
		"persistent": true,
		"nodepath": get_path(),
		"parent": get_parent().get_path(),
		"resources": {
			"resource": resource,
		},
		"cabin": {
			"posX" : %ElevatorCabin.position.x,
			"posY" : %ElevatorCabin.position.y,
		}
	}

func loading(input:Dictionary) -> bool:
	if input.has_all(["resources","cabin"]):
		if input["resources"].has("resource"):
			resource = input["resources"]["resource"]
		if input["cabin"].has_all(["posX","posY"]):
			%ElevatorCabin.position = Vector2(input["cabin"]["posX"],input["cabin"]["posY"])
		setup_cabin()
		if resource.active:
			Signals.elevator_move_to_key.emit(resource.id,resource.movingToStop,true)
		return true
	return false
#endregion
