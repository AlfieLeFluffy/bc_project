extends Node
## The Settings Controller autoload script 

#region Constants
## A constant holding the preloaded reference for the [SettingsMenu]
const PRELOAD_SETTINGS_MENU: Resource = preload("res://scripts/settings/settings_menu.tscn")

## A constant holding possible resolutions
const RESOLUTION_DICTIONARY: Dictionary = {
	0: Vector2(640,360),
	1: Vector2(1280,720),
	2: Vector2(1920,1080),
	3: Vector2(2560,1440),
}

## A constant holding the config file filepath 
const CONFIG_FILEPATH: String = "user://config.cfg"
## A constant holding the default config file filepath
const DEFAULT_CONFIG_FILEPATH: String = "res://scripts/settings/default_config.cfg"

## A variables holding reference to the callable method that adds and positions the persistence menu to the scene tree.
@onready var OPEN_MENU_METHOD: Callable = GameController.open_popup_menu
#endregion

#region Signals
## Signal for notifying [SettingsController] to open a settings menu.
signal s_SettingsMenuOpen()

## Signal for notifying other scripts that a new configuration was loaded.
signal s_ConfigLoaded()
## Signal for notifying [SettingsController] that a setting was updated.
signal s_ConfigUpdate()
## Signal for notifying [SettingsController] to save over the config file.
signal s_ConfigSave()
## Signal for notifying other scripts that a new language was selected. This procks all translatable text to get transalted.
signal s_Retranslate()
#endregion

#region Runtime Variables
## A [ConfigFile] variable instance holding all current settings.  
var config: ConfigFile
#endregion


"""
--- Methods
"""
#region Setup Methods
## Settings Controller initial setup 
func _ready() -> void:
	load_config_file()
	update_settings()
	
	s_ConfigUpdate.connect(update_settings)
	s_ConfigSave.connect(save_settings)
	s_SettingsMenuOpen.connect(open_settings_menu)
#endregion



#region Settings Menu Methods
## A method that instantiates a [SettingsMenu] and uses a setup callable variable to add it into the scene.
func open_settings_menu() -> void:
	var settingsMenu: SettingsMenu = PRELOAD_SETTINGS_MENU.instantiate()
	var menu: Node = OPEN_MENU_METHOD.call(settingsMenu)
#endregion



#region Config File Methods
## A method that load a config file or creates a new one from the default config is non is available.
## If a config is already loaded the method end early.  
func load_config_file() -> void:
	if config:
		return
	
	if not FileAccess.file_exists(CONFIG_FILEPATH):
		config = create_new_config()
		return
	
	config = ConfigFile.new()
	var err = config.load(CONFIG_FILEPATH)
	if err != OK:
		config = create_new_config()
		printerr("Error loading config file. Created/Rewriten a new config file")

## A method that save or rewrites an existing config file.
func save_settings() -> void:
	config.save(CONFIG_FILEPATH)

## A method that creates, saves and returns a new [ConfigFile] based on the default config file.
func create_new_config() -> ConfigFile:
	var newConfig: ConfigFile = get_default_config_file()
	newConfig.save(CONFIG_FILEPATH)
	return newConfig

## A methods that loads up the default config file and returns it. [br]
func get_default_config_file() -> ConfigFile:
	var loadedConfig: ConfigFile = ConfigFile.new() 
	loadedConfig.load(DEFAULT_CONFIG_FILEPATH)
	return loadedConfig

## A method that checks the intergrity of the current [ConfigFile] against the default config file.
## This is done by loading the default config file and then checking the existence of all sections
## and section keys in the current config file against the default one. If the current config file
## is missing a sectino or key the method return false, otherwise it return true.
func check_config_file_integrity() -> bool:
	var default_config_file:ConfigFile = ConfigFile.new()
	default_config_file.load(DEFAULT_CONFIG_FILEPATH)
	for section in default_config_file.get_sections():
		for key in default_config_file.get_section_keys(section):
			if not config.has_section_key(section,key):
				printerr("Config file intergry fault at section:"+ section +" and key:" + key+". Reseting to default settings.")
				return false
	return true
#endregion



#region SET/GET Setting Methods
## A method that checks for existence of a section and key inside the current config
## and then returning their value. If either the section. key or the current config does
## not exist the method return null.[br]
##
## - [param section] is a [String] argument.
## - [param key] is a [String] argument.
func get_setting(section: String, key: String):
	if not config:
		return null
	
	if not config.has_section_key(section,key):
		return null
	
	return config.get_value(section,key)

## A method that return the current selected profile ID. If the config does not 
## have this section it return an empty [String]
func get_profile_id() -> String:
	if config.has_section_key("Profile","ID"):
		return config.get_value("Profile", "ID")
	return ""

## A method that sets the current selected profile ID inside the config and saves
## the config file. [br]
##
## - [param profileID] is a [String] argument.
func set_profile_id(profileID: String) -> void:
	config.set_value("Profile","ID",profileID)
	save_settings()
#endregion



#region Update Settings Methods
## A method that check the integrity of the config file and then sequentially updates
## all settings and preference aspects that config file holds. 
func update_settings() -> void:
	if not check_config_file_integrity():
		config = create_new_config()
	update_gameplay()
	update_graphics()
	update_audio()
	save_settings()

## A method that updates all settings relevant to the gameplay side based on the current config file.
func update_gameplay() -> void:
	var toRetranslate: bool = false
	if TranslationServer.get_locale() != config.get_value("Gameplay", "Language"):
		toRetranslate = true
	TranslationServer.set_locale(config.get_value("Gameplay", "Language"))
	if toRetranslate:
		emit_signal("s_Retranslate")

## A method that updates all settings relevant to the visual side based on the current config file.
func update_graphics() -> void:
	DisplayServer.window_set_mode(config.get_value("Graphics", "ScreenMode"))
	# Sets window resolution
	DisplayServer.window_set_size(config.get_value("Graphics", "Resolution"))
	# If window mode windowed is selected it repositions the window into the middle of the screen
	if config.get_value("Graphics", "ScreenMode") == 0:
		DisplayServer.window_set_position(DisplayServer.screen_get_size()/2-DisplayServer.window_get_size()/Vector2i(2.0,4.0))
	DisplayServer.window_set_vsync_mode(config.get_value("Graphics", "Vsync"))

## A method that updates all settings relevant to the audio side based on the current config file.
func update_audio() -> void:
	for bus in config.get_section_keys("AudioVolume"):
		AudioManager.set_bus_volume(AudioManager.get_bus_enum(bus),config.get_value("AudioVolume", bus))

## A method that return a scaled up or down font size based on the scale in the current config file.[br]
##
## - [param base] is an [int] argument of the original unscaled font size.
func scale_font_size(base: int) -> int:
	return int(base * config.get_value("Gameplay", "TextScale"))
#endregion
