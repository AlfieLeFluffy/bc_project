class_name ElevatorResource extends Resource

@export_category("Elevator Information")
@export var id: String
@export var timeline: String
@export_flags("Left","Right") var openning = 0b10

const OPENNING_LEFT: int = 0b01
const OPENNING_RIGHT: int = 0b10
const OPENNING_BOTH: int = 0b11

@export_category("Movement Information")
@export_range(10.0,150.0,1.0,"For setting elevator speek") var speed = 70.0
@export var active: bool = false
@export var startupTimeout: bool = false
@export var startupTimeoutDuration: float = 1.0
var tween: Tween

@export_category("Elevator Stops")
@export var currentStop: String
@export var movingToStop: String

func set_active(state: bool) -> void:
	active = state
