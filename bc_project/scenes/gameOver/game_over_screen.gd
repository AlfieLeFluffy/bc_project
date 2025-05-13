class_name GameOverScreen extends CanvasLayer

const GAME_OVER_TEXT_FORMAT: String = "[color=#%s][font_size=%s]%s\n[color=#%s][font_size=%s]%s"

@export var info: Dictionary

func _ready() -> void:
	Signals.s_CameraTrackedNodeSetEmpty.emit()
	
	setup_background(info)
	
	if info.has("achievement"):
		GameController.s_AchievementSet.emit(info["achievement"])
	
	if info.has_all(["name","description"]):
		%GameOverText.text = GAME_OVER_TEXT_FORMAT % [Global.color_Highlight.to_html(),str(SettingsController.scale_font_size(36)),tr(info["name"]),Global.color_TextBright.to_html(),str(SettingsController.scale_font_size(24)),tr(info["description"])]


func setup_background(input: Dictionary) -> void:
	%Background.visible = true
	%Background.modulate = Color.TRANSPARENT
	var color: Color = Color.WHITE
	if info.has("color"):
		color = color.lerp(info["color"],0.8)
	GameController.fade_to_color(%Background,color,2.5)

func _unhandled_input(event: InputEvent) -> void:
	if visible:
		get_viewport().set_input_as_handled()

func _process(delta: float) -> void:
	pass

func _on_load_button_pressed() -> void:
	PersistenceController.s_PersistenceMenuOpen.emit(PersistenceMenu.e_Mode.LOAD)

func _on_main_menu_button_pressed() -> void:
	GameController.change_scene("main_menu")
