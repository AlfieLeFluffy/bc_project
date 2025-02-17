extends Node

"""
--- Gloabal Signals
"""



"""
--- Runtime Variables
"""

@onready var config = SettingsController.config

@onready var GraphicsMenuList = $Menu/TabContainer/Graphics/VB
@onready var WinMode = GraphicsMenuList.get_node("ModeOptionButton")
@onready var WinSize = GraphicsMenuList.get_node("SizeOptionButton")
@onready var Vsync = GraphicsMenuList.get_node("VsyncOptionButton")

@onready var AudioMenuList = $Menu/TabContainer/Audio/VB
@onready var MasterSl = AudioMenuList.get_node("MasterSlider")
@onready var SoundSl = AudioMenuList.get_node("SoundSlider")
@onready var MusicSl = AudioMenuList.get_node("MusicSlider")
@onready var DialogueSl = AudioMenuList.get_node("DialogueSlider")



"""
--- Setup Methods
"""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_graphics()
	setup_sound()

"""
--- Runtime Methods
"""


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_menu") and not GameController.FocusSet:
		queue_free()
	elif event.is_action_pressed("ui_menu") and GameController.FocusSet:
		GameController.release_focus()
	get_viewport().set_input_as_handled()

"""
--- Custom Methods
"""

func setup_graphics() -> void:
	if config.has_section_key("Graphics", "ScreenMode"):
		WinMode.selected = config.get_value("Graphics", "ScreenMode")
	if config.has_section_key("Graphics", "Resolution"):
		WinSize.selected = SettingsController.resolutionsDict.find_key(config.get_value("Graphics", "Resolution"))
	if config.has_section_key("Graphics", "Vsync"):
		Vsync.selected = config.get_value("Graphics", "Vsync")

func setup_sound() -> void:
	if config.has_section("AudioVolume"):
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
