class_name AnimationController extends Node

@export_category("Animation nodes setup")
@export var characterBody: CharacterBody2D = null
@export var animatedSprite: AnimatedSprite2D = null

var active: bool = true

func _ready() -> void:
	if not characterBody or not animatedSprite:
		active = false
		self.set_process(false)

func _physics_process(delta: float) -> void:
	if not active:
		return
	
	if characterBody.is_on_floor():
		if characterBody.velocity.x == 0 and animatedSprite.sprite_frames.has_animation("idle"):
			animatedSprite.play("idle")
		if characterBody.velocity.x != 0 and animatedSprite.sprite_frames.has_animation("walk"):
			animatedSprite.play("walk")
	else:
		if animatedSprite.sprite_frames.has_animation("falling"):
			animatedSprite.play("falling")
