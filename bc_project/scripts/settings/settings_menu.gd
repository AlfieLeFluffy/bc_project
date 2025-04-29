class_name SettingsMenu extends Control

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

var popupMenu: PopupMenuController

"""
--- Setup Methods
"""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	popupMenu = PopupMenuController.get_popup_menu(self)
	
	%SaveButton.grab_focus()
	
	setup_gameplay()
	setup_graphics()
	setup_sound()

"""
--- Runtime Methods
"""


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_menu") or event.is_action_pressed("detective_board_toggle"):
		close_menu()

func close_menu() -> void:
	if popupMenu:
		popupMenu.popdownKill.emit()
	else:
		queue_free()

"""
--- Custom Methods
"""
func setup_gameplay() -> void:
	%LanguageOptionButton.selected = LANG_DICT.find_key(config.get_value("Gameplay", "Language"))
	%TextScaleSlider.value = config.get_value("Gameplay", "TextScale")

func setup_graphics() -> void:
	%ModeOptionButton.selected = config.get_value("Graphics", "ScreenMode")
	%SizeOptionButton.selected = SettingsController.RESOLUTION_DICTIONARY.find_key(config.get_value("Graphics", "Resolution"))
	%VsyncOptionButton.selected = config.get_value("Graphics", "Vsync")

func setup_sound() -> void:
	%MasterSlider.value = config.get_value("AudioVolume", "Master")
	%SoundSlider.value = config.get_value("AudioVolume", "SFX")
	%MusicSlider.value = config.get_value("AudioVolume", "Music")
	%DialogueSlider.value = config.get_value("AudioVolume", "Dialogue")

"""
--- Node Signal Methods
"""

func _on_save_button_pressed() -> void:
	SettingsController.s_ConfigUpdate.emit()
	SettingsController.s_ConfigSave.emit()
	close_menu()

func _on_apply_button_pressed() -> void:
	SettingsController.s_ConfigUpdate.emit()

func _on_language_option_button_item_selected(index: int) -> void:
	if LANG_DICT.has(index):
		config.set_value("Gameplay", "Language", LANG_DICT[index])

func _on_text_scale_slider_value_changed(value: float) -> void:
	config.set_value("Gameplay", "TextScale", value)




func _on_mode_option_button_item_selected(index: int) -> void:
	config.set_value("Graphics", "ScreenMode", index)

func _on_size_option_button_item_selected(index: int) -> void:
	config.set_value("Graphics", "Resolution", SettingsController.RESOLUTION_DICTIONARY[index])

func _on_vsync_option_button_item_selected(index: int) -> void:
	config.set_value("Graphics", "Vsync", index)


func _on_master_slider_value_changed(value: float) -> void:
	config.set_value("AudioVolume", "Master", value)

func _on_sound_slider_value_changed(value: float) -> void:
	config.set_value("AudioVolume", "SFX", value)

func _on_music_slider_value_changed(value: float) -> void:
	config.set_value("AudioVolume", "Music", value)

func _on_dialogue_slider_value_changed(value: float) -> void:
	config.set_value("AudioVolume", "Dialogue", value)
