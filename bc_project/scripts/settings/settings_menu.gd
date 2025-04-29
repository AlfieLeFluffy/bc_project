class_name SettingsMenu extends Control

#region Runtime Variables
## A variable holding a direct reference to the [SettingsController] [ConfigFile] instance.
@onready var config = SettingsController.config

## A variable holding the possible [PopupMenuController] instance if any is found.
var popupMenu: PopupMenuController
#endregion

"""
--- Setup Methods
"""
#region Setup Methods
## Setup of the [SettingsMenu]
func _ready() -> void:
	popupMenu = PopupMenuController.get_popup_menu(self)
	
	setup_settings()
	
	%SaveButton.grab_focus()

## A master method for setting up settings tabs. Calls other methods that setup each tab.
func setup_settings() -> void:
	setup_gameplay()
	setup_graphics()
	setup_sound()

## A method that sets up language options and font size scale options in the gameplay tab.
func setup_gameplay() -> void:
	%LanguageOptionButton.clear()
	for key: int in SettingsConstants.LANGUAGE_DICTIONARY_NAME.keys():
		%LanguageOptionButton.add_item(SettingsConstants.LANGUAGE_DICTIONARY_NAME[key],key)
	%LanguageOptionButton.selected = SettingsConstants.LANGUAGE_DICTIONARY_KEY.find_key(config.get_value("Gameplay", "Language"))
	
	%TextScaleSlider.value = config.get_value("Gameplay", "TextScale")

## A method that sets up graphics options in the graphics tab.
func setup_graphics() -> void:
	%ModeOptionButton.clear()
	for key: int in SettingsConstants.WINDOW_MODE_DICTIONARY.keys():
		%ModeOptionButton.add_item(SettingsConstants.WINDOW_MODE_DICTIONARY[key],key)
	%ModeOptionButton.selected = SettingsConstants.WINDOW_MODE_DICTIONARY.keys().find(config.get_value("Graphics", "ScreenMode"))
	
	%SizeOptionButton.clear()
	for key: int in SettingsConstants.RESOLUTION_DICTIONARY.keys():
		var value: Vector2i = SettingsConstants.RESOLUTION_DICTIONARY[key]
		%SizeOptionButton.add_item("%sx%s" % [value.x,value.y],key)
	%SizeOptionButton.selected = SettingsConstants.RESOLUTION_DICTIONARY.find_key(config.get_value("Graphics", "Resolution"))
	
	%VsyncOptionButton.clear()
	for key: int in SettingsConstants.TOGGLE_DICTIONARY.keys():
		%VsyncOptionButton.add_item(SettingsConstants.TOGGLE_DICTIONARY[key],key)
	%VsyncOptionButton.selected = config.get_value("Graphics", "Vsync")

## A method that sets up audio settings in the audio tab.
func setup_sound() -> void:
	for slider in [[%MasterSlider, "Master"],[%SoundSlider, "SFX"],[%MusicSlider, "Music"],[%DialogueSlider, "Dialogue"]]:
		setup_audio_slider(slider[0],slider[1])

## A method that sets up a single audio slider with min, max values, step value and current value.
##
## - [param slider] is an [HSlider] reference to the slider that should be set up.
## - [param key] is a [String] parameter the find the current value in config.
func setup_audio_slider(slider: HSlider, key: String) -> void:
	slider.min_value = SettingsConstants.AUDIO_SLIDER_RANGE.x
	slider.max_value = SettingsConstants.AUDIO_SLIDER_RANGE.y
	slider.step = SettingsConstants.AUDIO_SLIDER_STEP
	slider.value = config.get_value("AudioVolume", key)
#endregion



"""
--- Runtime Methods
"""
#region Runtime Methods
## A overwriten method for capturing player input. If the menu or detective board
## inputs are pressed the menu closes without saving.
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_menu") or event.is_action_pressed("detective_board_toggle"):
		close_menu()

## A method that closes the menu if in the option menu or queues free if not.
func close_menu() -> void:
	if popupMenu:
		popupMenu.popdownKill.emit()
	else:
		queue_free()
#endregion


"""
--- Signal Methods
"""
#region Save Settings Signals
## If the save button is pressed the new configuration is applied, saved and the
## menu closes.
func _on_save_button_pressed() -> void:
	SettingsController.s_ConfigUpdate.emit()
	SettingsController.s_ConfigSave.emit()
	close_menu()

## If the apply button is pressed only the configuration gets updated, but not 
## saved and the menu does not close.
func _on_apply_button_pressed() -> void:
	SettingsController.s_ConfigUpdate.emit()
#endregion

#region Gameplay Settings Signals
## A signal method that updates the language option inside config.[br]
##
## - [param index] is an [int] index ponting to the selected item.
func _on_language_option_button_item_selected(index: int) -> void:
	var id: int = %LanguageOptionButton.get_item_id(index)
	if SettingsConstants.LANGUAGE_DICTIONARY_KEY.has(id):
		config.set_value("Gameplay", "Language", SettingsConstants.LANGUAGE_DICTIONARY_KEY[id])

## A signal method that updates the language option inside config.[br]
##
## - [param value] is a [flaot] argument within the contraints of slider.
func _on_text_scale_slider_value_changed(value: float) -> void:
	config.set_value("Gameplay", "TextScale", value)
#endregion

#region Graphics Settings Signals
## A signal method that updates the window mode inside config.[br]
##
## - [param index] is an [int] index ponting to the selected item.
func _on_mode_option_button_item_selected(index: int) -> void:
	var id: int = %ModeOptionButton.get_item_id(index)
	if SettingsConstants.WINDOW_MODE_DICTIONARY.has(id):
		config.set_value("Graphics", "ScreenMode", id)

## A signal method that updates the resolution size inside config.[br]
##
## - [param index] is an [int] index ponting to the selected item.
func _on_size_option_button_item_selected(index: int) -> void:
	var id: int = %SizeOptionButton.get_item_id(index)
	if SettingsConstants.RESOLUTION_DICTIONARY.has(id):
		config.set_value("Graphics", "Resolution", SettingsConstants.RESOLUTION_DICTIONARY[id])

## A signal method that updates the enable vsync option inside config.[br]
##
## - [param index] is an [int] index ponting to the selected item.
func _on_vsync_option_button_item_selected(index: int) -> void:
	var id: int = %VsyncOptionButton.get_item_id(index)
	if SettingsConstants.TOGGLE_DICTIONARY.has(id):
		config.set_value("Graphics", "Vsync", id)
#endregion

#region Audio Settings Signals
## A signal method that updates master bus volume inside config.[br]
##
## - [param value] is a [flaot] argument within the contraints of slider.
func _on_master_slider_value_changed(value: float) -> void:
	if value >= 0.0 and value <= 1.0:
		config.set_value("AudioVolume", "Master", value)

## A signal method that updates sfx bus volume inside config.[br]
##
## - [param value] is a [flaot] argument within the contraints of slider.
func _on_sound_slider_value_changed(value: float) -> void:
	if value >= 0.0 and value <= 1.0:
		config.set_value("AudioVolume", "SFX", value)

## A signal method that updates music bus volume inside config.[br]
##
## - [param value] is a [flaot] argument within the contraints of slider.
func _on_music_slider_value_changed(value: float) -> void:
	if value >= 0.0 and value <= 1.0:
		config.set_value("AudioVolume", "Music", value)

## A signal method that updates dialogue bus volume inside config.[br]
##
## - [param value] is a [flaot] argument within the contraints of slider.
func _on_dialogue_slider_value_changed(value: float) -> void:
	if value >= 0.0 and value <= 1.0:
		config.set_value("AudioVolume", "Dialogue", value)
#endregion
