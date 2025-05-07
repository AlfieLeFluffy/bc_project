class_name QuickTextEffect extends CanvasLayer

## A constant holding the text format for quick text
const QUICK_TEXT_FORMAT: String = "[font_size=%s][color=#%s]%s"

## A variable holding the quick text
@export var text: String = ""
## A variable holding the timeout timer
@export var timeout: float = 1.0
## A variable holding the timeout timer
@export var fontSize: int = 48
## A variable holding the text color
@export var color: Color = Global.color_Highlight

@onready var originalPosition: Vector2 = %TextControl.position
var tween: Tween
var waveMax: int = 4
var waveOffset: int = 20

func _ready() -> void:
	%QuickTextLabel.parse_bbcode(QUICK_TEXT_FORMAT % [SettingsController.scale_font_size(fontSize), color.to_html(), tr(text)])
	await start_animation()
	await get_tree().create_timer(timeout).timeout
	queue_free()

func start_animation() -> bool:
	for index in range(1,waveMax):
		tween = create_tween()
		tween.tween_property(%TextControl, "position", originalPosition + Vector2(waveOffset * waveMax / index,0), 0.1)
		await tween.finished
		
		tween = create_tween()
		tween.tween_property(%TextControl, "position", originalPosition, 0.1)
		await tween.finished
	return true
