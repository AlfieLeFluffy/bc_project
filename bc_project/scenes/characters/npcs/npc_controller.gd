extends CharacterBody2D

"""
--- Physics constants
"""

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

"""
--- Exported variables
"""

@export_group("npc information")
@export var npcName: String

@export_group("interactive flags")
@export var active: bool = false
@export var mouseHover: bool = false
@export var inRadius: bool = false

@export_group("dialog")
@export var dialogIndex: int = 0 
@export var dialogs: Array[DialogueResource]
@export var titleIndex: int = 0 
@export var titles: PackedStringArray

"""
--- Input functions
"""

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and active:
		$DialogHandler.dialog_start()

"""
--- Runtime functions
"""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mouseHover and inRadius:
		active = true
	else:
		active = false

func _physics_process(delta: float) -> void:
	var direction
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

"""
--- Activate/deactivate interactivity
"""

func activate_hover() -> void:
	pass

func deactivate_hover() -> void:
	pass

func activate_interactivity() -> void:
	pass

func deactivate_interactivity() -> void:
	pass
