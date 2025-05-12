class_name WanderNpcState extends State

"""
--- Exported Physics Constants
"""
@export_group("Character Body Constants")
@export var SPEED: int = 60.0
@export var JUMP_VELOCITY: int = -200.0
@export var characterBody: CharacterBody2D

@export_group("Wander Varibales")
@export var minWanderTime: float = 1
@export var maxWanderTime: float = 3

var moveDirection: Vector2
var wanderTime: float
var castAhead: RayCast2D

"""
--- State Setup/Exit functions
"""

func _ready() -> void:
	Signals.connect("start_npc_conversation_state", start_conversation)

func Enter() -> void:
	randomize_wander()

func Exit() -> void:
	pass

"""
--- State Runtime functions
"""

func Process(delta: float) -> void:
	if wanderTime > 0:
		wanderTime -= delta
	else:
		randomize_wander()

func Physics_Process(delta: float) -> void:
	if characterBody:
		characterBody.velocity = moveDirection * SPEED
	
	if %CastAhead.is_colliding():
		moveDirection = moveDirection * -1
		set_cast()
	
	if wanderTime <= 0:
		Transition.emit(self,"Idle")

"""
--- Randomize functions
"""

func randomize_wander() -> void:
	moveDirection.x = [1,-1].pick_random() #Vector2(randi_range(1,-1),0)
	set_cast()
	wanderTime = randf_range(minWanderTime,maxWanderTime)
	

func set_cast() -> void:
	if moveDirection.x == 1:
		%CastAhead.target_position.y = abs(%CastAhead.target_position.y)
	elif moveDirection.x == -1:
		%CastAhead.target_position.y = abs(%CastAhead.target_position.y) * -1

"""
--- Starting conversation function
"""

func start_conversation(npc) -> void:
	if characterBody == npc and get_parent().currentState == self:
		Transition.emit(self,"Talking")
