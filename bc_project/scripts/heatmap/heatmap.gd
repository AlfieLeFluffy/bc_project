class_name Heatmap extends Resource

enum directionType {ANY,
	TOP,
	BOTTOM,
	LEFT,
	RIGHT,
	MIDDLE_STRIP,
}

@export_group("Heatmap Variables")
@export var heatmap: Array[Array]
@export var size: Vector2

@export_group("Setup Variables")
@export var base: float = 0.0
@export var floor: float = 0.0
@export var ceiling: float = 1.0

@export_group("Conversion Variables")
@export var pixelSize: Vector2

#region Setup Methods
func setup(_size: Vector2 = Vector2(1,1), _pixelSize: Vector2 = Vector2(1,1)) -> void:
	size = _size
	pixelSize = _pixelSize
	
	heatmap = create_heatmap(size,base)

func create_heatmap(_size: Vector2, _base: float) -> Array[Array]:
	var output: Array[Array]
	for x in range(_size.x):
		var column: Array[float]
		for y in range(_size.y):
			column.append(_base)
		output.append(column)
	return output
#endregion



#region Conversion Methods
func position_to_cords(position: Vector2) -> Vector2:
	return position / pixelSize

func cords_to_position(cords: Vector2) -> Vector2:
	return cords * pixelSize
#endregion



#region Validation Methods
func valid_position(position: Vector2) -> bool:
	return valid_cords(position_to_cords(position))

func valid_cords(cords: Vector2) -> bool:
	if cords.x < 0 or cords.y < 0:
		return false
	if cords.x > (size.x -1) or cords.y > (size.y -1):
		return false
	return true

func validate_rect_inside(cords: Vector2, rect: Vector2 ) -> bool:
	var half: Vector2 = rect / 2
	if cords.x + half.x > size.x or cords.x - half.x < 0:
		return false
	return true
#endregion



#region Get Methods
func get_value_position(position: Vector2) -> float:
	if valid_position(position):
		return get_value_cords(position_to_cords(position))
	return floor

func get_value_cords(cords: Vector2) -> float:
	if valid_cords(cords):
		return heatmap[int(cords.x)][int(cords.y)]
	return floor

func get_direction_ranges(direction: directionType) -> Array[Vector2]:
	var output: Array[Vector2]
	match direction:
		directionType.ANY:
			output.append(Vector2(0,size.x))
			output.append(Vector2(0,size.y))
		directionType.TOP:
			output.append(Vector2(0,size.x))
			output.append(Vector2(0,0))
		directionType.BOTTOM:
			output.append(Vector2(0,size.x))
			output.append(Vector2(size.y,size.y))
		directionType.LEFT:
			output.append(Vector2(size.x,size.x))
			output.append(Vector2(0,size.y))
		directionType.RIGHT:
			output.append(Vector2(0,0))
			output.append(Vector2(0,size.y))
		directionType.MIDDLE_STRIP:
			output.append(Vector2(0,size.x))
			output.append(Vector2(size.y/3,(size.y/3)*2))
	return output
#endregion



#region Find Methods
func find_space(generator: RandomNumberGenerator, ranges:Array[Vector2], tolerance: float, timeout: int = 50) -> Vector2:
	var output: Vector2
	output = Vector2(generator.randi_range(ranges[0].x,ranges[0].y),generator.randi_range(ranges[1].x,ranges[1].y))
	while get_value_cords(output) > tolerance:
		if timeout < 0:
			return Vector2(-1,-1)
		output = Vector2(generator.randi_range(ranges[0].x,ranges[0].y),generator.randi_range(ranges[1].x,ranges[1].y))
		timeout -= 1
	return output

func find_position(generator: RandomNumberGenerator, direction: directionType = directionType.ANY, tolerance: float = 0.0) -> Vector2:
	var output: Vector2
	var ranges: Array[Vector2] = get_direction_ranges(direction)
	
	output = find_space(generator,ranges,tolerance)
	
	return cords_to_position(output)


func find_position_by_size(generator: RandomNumberGenerator, rect: Vector2, direction: directionType = directionType.ANY, tolerance: float = 0.0, timeout: int = 50) -> Vector2:
	var rectSize:Vector2 = rect / pixelSize
	var output: Vector2
	var ranges: Array[Vector2] = get_direction_ranges(direction)
	
	output = find_space(generator,ranges,tolerance)
	while not validate_rect_inside(output,rectSize):
		output = find_space(generator,ranges,tolerance)
	
	return cords_to_position(output)
#endregion



#region Set Methods
func set_value(position: Vector2, value: float, heat: bool = true, radius: int = 2) -> bool:
	if not set_value_precise(position,value):
		return false
	
	for i in range(1,radius+1):
		set_heat_value(position, i, snapped(value/(radius*i),0.001))
	
	return true

func set_heat_value(position: Vector2, offset: int, value: float,) -> void:
	for i in range(position.x-offset,position.x+offset+1):
		combine_values(Vector2(i,position.y-offset),value)
		combine_values(Vector2(i,position.y+offset),value)
	for i in range(position.y-offset+1,position.y+offset):
		combine_values(Vector2(position.x-offset,i),value)
		combine_values(Vector2(position.x+offset,i),value)

func set_value_rect(start: Vector2, end: Vector2, heat: bool = true, radius: int = 2) -> bool:
	
	return false

func set_value_precise(position: Vector2, value: float) -> bool:
	if valid_cords(position):
		heatmap[int(position.x)][int(position.y)] = value
		return true
	return false
#endregion



#region Combine Methods
func combine_values(position: Vector2, value: float) -> void:
	set_value_precise(position, min(ceiling,max(floor,get_value_cords(position)+value)))

func combine_value_average(position: Vector2, value: float) -> void:
	set_value_precise(position, min(ceiling,max(floor,(get_value_cords(position)+value)/2)))
#endregion

#region Output/Print Methods
func print_heatmap() -> void:
	for x in size.x:
		print(heatmap[x])
#endregion
