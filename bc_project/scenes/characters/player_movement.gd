extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -200.0

var jump: bool = false
var direction

func _ready() -> void:
	Signals.connect("update_overlay",update_overlay)

func _unhandled_input(event: InputEvent) -> void:
	if (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up")) and is_on_floor():
		jump = true
	
	direction = Input.get_axis("ui_left", "ui_right")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if jump:
		velocity.y = JUMP_VELOCITY
		jump = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func update_overlay() -> void:
	$main_overlay.UpdateUI()
