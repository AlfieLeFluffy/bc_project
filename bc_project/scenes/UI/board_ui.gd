extends CanvasLayer

const SPEED = 3

var velocity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MarginContainer.visible = 0
	$Board.visible = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("table_toggle"):
		toggle_board()

func _physics_process(delta: float) -> void:
	if Global.InMenu and $Board.visible:
		var horizontal := Input.get_axis("ui_left", "ui_right")
		var vertical := Input.get_axis("ui_up", "ui_down")
		var direction = Vector2(horizontal*SPEED,vertical*SPEED)
		if horizontal or vertical:
			$Board/TextureRect.position = $Board/TextureRect.position + direction

func toggle_board() -> void:
	if $Board.visible:
		Global.CloseMenu()
		$MarginContainer.visible = 0
		$Board.visible = 0
	else:
		Global.OpenMenu()
		$MarginContainer.visible = 1
		$Board.visible = 1
