class_name AreaTrigger extends Area2D

#region Varibles and Constants
@export_category("Base Info")
@export var maxUses: int = 1
@export var timesUsed: int = 0
@export_category("Collision Shape")
@export var collisionShape: Shape2D
@export_category("Trigger Flags")
@export_flags("Entered","Exited") var triggerOn = 1
@export_flags("Player Collision","Npc Collision") var triggerObject = 3

var colisionShapeInstance: CollisionShape2D

const PLAYER_COLLISION_BIT = 0b01
const NPC_COLLISION_BIT = 0b10

const ENTERED_TRIGGER_BIT = 0b01
const EXITED_TRIGGER_BIT = 0b10
#endregion

#region Setup Methods
func _ready() -> void:
	self.add_to_group("Persistent")
	if collisionShape:
		colisionShapeInstance = CollisionShape2D.new()
		colisionShapeInstance.set_shape(collisionShape)
		self.add_child(colisionShapeInstance)
		self.body_shape_entered.connect(_on_body_shape_entered)
		self.body_shape_exited.connect(_on_body_shape_exited)
#endregion

#region Runtime Methods
func _colision_enter_player(player: Player) -> void:
	pass

func _colision_enter_npc(npc: NPC) -> void:
	pass


func _colision_exit_player(player: Player) -> void:
	pass

func _colision_exit_npc(npc: NPC) -> void:
	pass
#endregion

#region Signal Methods
func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if not (triggerOn & ENTERED_TRIGGER_BIT):
		return
	if timesUsed >= maxUses and maxUses > 0:
		return
	if (triggerObject & PLAYER_COLLISION_BIT) and body is Player:
		_colision_enter_player(body)
	elif (triggerObject & NPC_COLLISION_BIT) and body is NPC:
		_colision_enter_npc(body)
	timesUsed += 1
 
func _on_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if not (triggerOn & EXITED_TRIGGER_BIT):
		return
	if timesUsed >= maxUses and maxUses > 0:
		return
	if (triggerObject & PLAYER_COLLISION_BIT) and body is Player:
		_colision_exit_player(body)
	elif (triggerObject & NPC_COLLISION_BIT) and body is NPC:
		_colision_exit_npc(body)
	timesUsed += 1
#endregion

#region Persistence Methods
func saving() -> Dictionary:
	return {
		"persistent": true,
		"nodepath": get_path(),
		"parent": get_parent().get_path(),
		"timesUsed": timesUsed,
	}

func loading(input:Dictionary) -> bool:
	if input.has_all(["timesUsed"]):
		timesUsed = input["timesUsed"]
		return true
	return false
#endregion
