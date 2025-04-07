extends Button

@export_range(1.0,3.0,0.1) var ration: float = 1.2

var originalSize: Vector2
var tween: Tween

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	originalSize = size
	
	self.mouse_entered.connect(stretch)
	self.mouse_exited.connect(reset)
	
	get_viewport().size_changed.connect(reset)

func stretch() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "size", originalSize * Vector2(ration,1.0),0.2)

func reset() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "size", originalSize,0.2)
