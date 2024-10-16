extends CanvasLayer

const SPEED = 3

var drag = false
var mouse_offset

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".visible = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("table_toggle"):
		toggle_board()
	elif event.is_action_pressed("drag"):
		drag = true
		mouse_offset = $Board.position - $Board.get_global_mouse_position()
	elif event.is_action_released("drag"):
		drag = false

func _physics_process(delta: float) -> void:
	if Global.InMenu and $".".visible and not drag:
		var horizontal := Input.get_axis("ui_left", "ui_right")
		var vertical := Input.get_axis("ui_up", "ui_down")
		var direction = Vector2(horizontal*SPEED,vertical*SPEED)
		if horizontal or vertical:
			$Board.position = $Board.position + direction
	elif Global.InMenu and $".".visible and drag:
		$Board.position = $Board.get_global_mouse_position() + mouse_offset
	
func toggle_board() -> void:
	if $".".visible:
		Global.CloseMenu()
		$".".visible = 0
	else:
		Global.OpenMenu()
		$".".visible = 1
