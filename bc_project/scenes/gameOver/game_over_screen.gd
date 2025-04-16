class_name GameOverScreen extends CanvasLayer

const GAME_OVER_TEXT_FORMAT: String = "[font_size=24]%s\n[font_size=14]%s"

@export var info: Dictionary

func _ready() -> void:
	Signals.s_CameraTrackedNodeSetEmpty.emit()
	
	if info.has("achievement"):
		GameController.s_AchievementSet.emit(info["achievement"])
	
	if info.has_all(["name","description"]):
		%GameOverText.text = GAME_OVER_TEXT_FORMAT % [tr(info["name"]),tr(info["description"])]
	if info.has("color"):
		%Background.material.set("shader_parameter/color", info["color"])

func _unhandled_input(event: InputEvent) -> void:
	if visible:
		get_viewport().set_input_as_handled()

func _process(delta: float) -> void:
	pass

func _on_load_button_pressed() -> void:
	PersistenceController.s_PersistenceMenuOpen.emit(PersistenceMenu.modeEnum.LOAD)

func _on_main_menu_button_pressed() -> void:
	GameController.change_scene("main_menu")
