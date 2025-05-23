class_name PopupMenuController extends CanvasLayer

enum popupDirection {LEFT,RIGHT,UP,DOWN}

@export_range(0,100,1) var windowOffset: int = 25

var  tween: Tween
@export var open: bool = false
@export var pernament: bool
@export var direction: popupDirection
@export var duration: float
@export var startPosition: Vector2i
@export var endPosition: Vector2i
@export var centerPosition: Vector2i

signal popup()
signal popdown()
signal popdownKill()

func setup(_content, _pernament: bool = false, _direction: popupDirection = popupDirection.LEFT, _size: Vector2i = get_tree().root.content_scale_size - Vector2i(1220,280), _duration: float = 0.5) -> void:
	popup.connect(pop_up)
	popdown.connect(pop_down)
	popdownKill.connect(pop_down_kill)
	
	pernament = _pernament
	direction = _direction
	duration = _duration
	%PopupMenu.size = _size
	if _content:
		%Content.add_child(_content)
	
	setup_background()
	

func setup_background() -> void:
	match direction:
		popupDirection.LEFT:
			%NinePatchLeft.visible = true
		popupDirection.RIGHT:
			%NinePatchRight.visible = true
		_:
			%NinePatchLeft.visible = true

static func get_popup_menu(start: Node) -> PopupMenuController:
	var parent = start.get_parent()
	while parent != null:
		if parent is PopupMenuController:
			return parent
		parent = parent.get_parent()
	return null

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event.is_action_pressed("interact"):
		if not Rect2(Vector2(),%PopupMenu.size).has_point($%Content.get_local_mouse_position()):
			if pernament:
				popdown.emit()
			else:
				popdownKill.emit()
	elif  event.is_action_pressed("ui_menu"):
		if pernament:
			popdown.emit()
		else:
			popdownKill.emit()
	get_viewport().set_input_as_handled()

func pop_up() -> void:
	open_menu()

func pop_down() -> void:
	close_menu()

func pop_down_kill() -> void:
	close_menu()
	if tween:
		await tween.finished
	kill_menu()

func open_menu() -> void: 
	open = true
	calculate_positions()
	%PopupMenu.position = centerPosition
	%PopupMenu.popup()
	%PopupMenu.position = startPosition
	setup_tween(startPosition,endPosition)

func close_menu() -> void:
	open = false
	if not tween:
		return
	setup_tween(endPosition,startPosition)

func kill_menu() -> void:
	if tween:
		tween.kill()
	queue_free()

func calculate_positions() -> void:
	var screenSize: Vector2i = get_viewport().get_visible_rect().size
	centerPosition = Vector2i((screenSize - %PopupMenu.position) / 2)
	match direction:
		popupDirection.LEFT:
			startPosition = Vector2i((-%PopupMenu.size.x),(screenSize.y-%PopupMenu.size.y)/2)
			endPosition = startPosition + Vector2i(%PopupMenu.size.x+windowOffset,0)
		popupDirection.RIGHT:
			startPosition = Vector2i((screenSize.x),(screenSize.y-%PopupMenu.size.y)/2)
			endPosition = startPosition - Vector2i(%PopupMenu.size.x+windowOffset,0)
		popupDirection.DOWN:
			startPosition = Vector2i((screenSize.x-%PopupMenu.size.x)/2,-%PopupMenu.size.y)
			endPosition = startPosition + Vector2i(0,%PopupMenu.size.y)
		popupDirection.UP:
			startPosition = Vector2i((screenSize.x-%PopupMenu.size.x)/2,screenSize.y)
			endPosition = startPosition - Vector2i(0,%PopupMenu.size.y+windowOffset)

func setup_tween(start: Vector2i, end: Vector2i) -> void:
	if not is_inside_tree():
		return
	tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops(1).set_parallel(1)
	tween.tween_property(%PopupMenu, "position",start, duration)
	tween.tween_property(%PopupMenu, "position",end, duration)

func _on_popup_menu_close_requested() -> void:
	close_menu()

func _on_content_child_exiting_tree(node: Node) -> void:
	close_menu()
