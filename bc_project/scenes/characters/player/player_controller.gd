extends CharacterBody2D

"""
--- Exported Variables
"""
@export_category("Physics Variables")
@export var walkSpeed = 120.0
@export var runSpeed = 200.0
@export var jumpVelocity = -300.0

"""
--- Runtime Variables
"""
var jump: bool = false
var direction: float

"""
--- Setup Methods
"""
func _ready() -> void:
	pass

"""
--- Runtime Methods
"""
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump = true

	direction = Input.get_axis("ui_left", "ui_right")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if jump:
		velocity.y = jumpVelocity
		jump = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction and Input.get_axis("ui_left", "ui_right") and Input.is_action_pressed("run"):
		velocity.x = direction * runSpeed
	elif direction and Input.get_axis("ui_left", "ui_right"):
		velocity.x = direction * walkSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, walkSpeed)

	set_direction_flip()
	move_and_slide()

# Depending on the current velocity either flips character towards the current diraction or towards the mouse if standing still
func set_direction_flip() -> void:
	if velocity.x == 0:
		if global_position.x - get_global_mouse_position().x > 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false

"""
--- Persistence Methods
"""
func saving() -> Dictionary:
	return {
		"persistent": true,
		"nodepath": get_path(),
		"parent": get_parent().get_path(),
		"posX": position.x,
		"posY": position.y
	}

func loading(input:Dictionary) -> bool:
	if input.has("posX") and input.has("posY"):
		position.x = input["posX"]
		position.y = input["posY"]
		return true
	return false
