class_name PopupMenuController extends Control

enum popupDirection {LEFT,RIGHT,UP,DOWN}

var  tween: Tween
@export var direction: popupDirection
@export var duration: float
@export var startPosition: Vector2i
@export var endPosition: Vector2i
@export var centerPosition: Vector2i

signal closeMenu()

func setup(_content, _direction: popupDirection = popupDirection.LEFT, _size: Vector2i = Vector2i(500,500), _duration: float = 0.5) -> void:
	closeMenu.connect(close_menu)
	get_viewport().size_changed.connect(recalculate_positions)
	
	direction = _direction
	duration = _duration
	%PopupMenu.size = _size
	if _content:
		%Content.add_child(_content)
	open_menu()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event.is_action_pressed("interact"):
		if not Rect2(Vector2(),$%Content.size).has_point($%Content.get_local_mouse_position()):
			closeMenu.emit()
	elif  event.is_action_pressed("ui_menu"):
		closeMenu.emit()
	get_viewport().set_input_as_handled()

func open_menu() -> void: 
	calculate_positions()
	$PopupMenu.position = centerPosition
	$PopupMenu.popup()
	$PopupMenu.position = startPosition
	setup_tween(startPosition,endPosition)

func close_menu() -> void:
	if tween.is_valid():
		return
	setup_tween(endPosition,startPosition)
	await tween.finished
	tween.kill()
	queue_free()

func calculate_positions() -> void:
	var screenSize: Vector2i = get_viewport().size
	centerPosition = Vector2i((screenSize - $PopupMenu.position) / 2)
	match direction:
		popupDirection.LEFT:
			startPosition = Vector2i((-$PopupMenu.size.x - 50),(screenSize.y-$PopupMenu.size.y)/2)
			endPosition = startPosition + Vector2i($PopupMenu.size.x+100,0)
		popupDirection.RIGHT:
			startPosition = Vector2i((screenSize.x + 50),(screenSize.y-$PopupMenu.size.y)/2)
			endPosition = startPosition - Vector2i($PopupMenu.size.x+100,0)
		popupDirection.DOWN:
			startPosition = Vector2i((screenSize.x-$PopupMenu.size.x)/2,-$PopupMenu.size.y-50)
			endPosition = startPosition + Vector2i(0,$PopupMenu.size.x+100)
		popupDirection.UP:
			startPosition = Vector2i((screenSize.x-$PopupMenu.size.x)/2,screenSize.y+50)
			endPosition = startPosition - Vector2i(0,$PopupMenu.size.x+100)

func recalculate_positions() -> void:
	calculate_positions()
	%PopupMenu.position = endPosition

func setup_tween(start: Vector2i, end: Vector2i) -> void:
	tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops(1).set_parallel(1)
	tween.tween_property(%PopupMenu, "position",start, duration)
	tween.tween_property(%PopupMenu, "position",end, duration)

func _on_popup_menu_close_requested() -> void:
	close_menu()

func _on_content_child_exiting_tree(node: Node) -> void:
	close_menu()
