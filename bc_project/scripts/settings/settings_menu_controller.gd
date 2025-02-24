extends Node

"""
--- Constants
"""
const LANG_DICT: Dictionary ={
	0:"en",
	1:"cz",
}

"""
--- Runtime Variables
"""

@onready var config = SettingsController.config

@onready var GameplayMenuList = $Menu/TabContainer/GAMEPLAY_TAB/VB
@onready var Language = GameplayMenuList.get_node("LanguageOptionButton")

@onready var GraphicsMenuList = $Menu/TabContainer/GRAPHICS_TAB/VB
@onready var WinMode = GraphicsMenuList.get_node("ModeOptionButton")
@onready var WinSize = GraphicsMenuList.get_node("SizeOptionButton")
@onready var Vsync = GraphicsMenuList.get_node("VsyncOptionButton")

@onready var AudioMenuList = $Menu/TabContainer/AUDIO_TAB/VB
@onready var MasterSl = AudioMenuList.get_node("MasterSlider")
@onready var SoundSl = AudioMenuList.get_node("SoundSlider")
@onready var MusicSl = AudioMenuList.get_node("MusicSlider")
@onready var DialogueSl = AudioMenuList.get_node("DialogueSlider")



"""
--- Setup Methods
"""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_gameplay()
	setup_graphics()
	setup_sound()

"""
--- Runtime Methods
"""


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_menu"):
		GameController.release_focus()
		queue_free()
	get_viewport().set_input_as_handled()

"""
--- Custom Methods
"""
func setup_gameplay() -> void:
	Language.selected = LANG_DICT.find_key(config.get_value("Gameplay", "Language"))

func setup_graphics() -> void:
	WinMode.selected = config.get_value("Graphics", "ScreenMode")
	WinSize.selected = SettingsController.resolutionsDict.find_key(config.get_value("Graphics", "Resolution"))
	Vsync.selected = config.get_value("Graphics", "Vsync")

func setup_sound() -> void:
	MasterSl.value = config.get_value("AudioVolume", "Master")
	SoundSl.value = config.get_value("AudioVolume", "SFX")
	MusicSl.value = config.get_value("AudioVolume", "Music")
	DialogueSl.value = config.get_value("AudioVolume", "Dialogue")

"""
--- Node Signal Methods
"""

func _on_save_button_pressed() -> void:
	SettingsController.emit_signal("updateSettings")
	SettingsController.emit_signal("saveSettings")
	queue_free()

func _on_apply_button_pressed() -> void:
	SettingsController.emit_signal("updateSettings")

func _on_language_option_button_item_selected(index: int) -> void:
	if LANG_DICT.has(index):
		config.set_value("Gameplay", "Language", LANG_DICT[index])

func _on_mode_option_button_item_selected(index: int) -> void:
	config.set_value("Graphics", "ScreenMode", index)

func _on_size_option_button_item_selected(index: int) -> void:
	config.set_value("Graphics", "Resolution", SettingsController.resolutionsDict[index])

func _on_vsync_option_button_item_selected(index: int) -> void:
	config.set_value("Graphics", "Vsync", index)



func _on_master_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		config.set_value("AudioVolume", "Master", MasterSl.value)

func _on_sound_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		config.set_value("AudioVolume", "SFX", SoundSl.value)

func _on_music_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		config.set_value("AudioVolume", "Music", MusicSl.value)

func _on_dialogue_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		config.set_value("AudioVolume", "Dialogue", DialogueSl.value)
