class_name IdleNpcState extends State

"""
--- Exported Physics Constants
"""
@export_group("Character Body Constants")
@export var SPEED: int = 60
@export var JUMP_VELOCITY: int = -200
@export var characterBody: CharacterBody2D

@export_group("Idle Varibales")
@export var minIdleTime: float = 1
@export var maxIdleTime: float = 3

var idleTime: float
var unableToWander: bool = false

"""
--- State Setup/Exit functions
"""

func _ready() -> void:
	Signals.connect("start_npc_conversation_state", start_conversation)

func Enter() -> void:
	randomize_idle()

func Exit() -> void:
	pass

"""
--- State Runtime functions
"""

func Process(delta: float) -> void:
	if idleTime > 0:
		idleTime -= delta

func Physics_Process(delta: float) -> void:
	if characterBody:
		characterBody.velocity = Vector2()
	
	if unableToWander:
		randomize_idle()
	
	if idleTime <= 0:
		Transition.emit(self,"Wander")
		unableToWander = true


"""
--- Randomize functions
"""

func randomize_idle() -> void:
	idleTime = randf_range(minIdleTime,maxIdleTime)
	
"""
--- Starting conversation function
"""

func start_conversation(npc) -> void:
	if characterBody == npc and get_parent().currentState == self:
		Transition.emit(self,"Talking")
