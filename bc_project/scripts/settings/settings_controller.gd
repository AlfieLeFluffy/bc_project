extends Node

"""
--- Gloabal Signals
"""

signal configReady

signal updateSettings
signal saveSettings

signal openSettingsMenu

signal retranslate

"""
--- Runtime Variables
"""

var config

const preloadSettingsMenu = preload("res://scripts/settings/settings_menu.tscn")

const resolutionsDict:Dictionary = {
	0: Vector2(640,360),
	1: Vector2(1280,720),
	2: Vector2(1920,1080),
	3: Vector2(2560,1440)
}

"""
--- Setup Methods
"""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not config:
		if not FileAccess.file_exists("user://config.cfg"):
			config = create_new_config()
		else:
			config = ConfigFile.new()
			var err = config.load("user://config.cfg")
			if err != OK:
				config = create_new_config()
				printerr("Error loading config file. Created/Rewriten a new config file")
	
	update_settings()
	
	updateSettings.connect(update_settings)
	saveSettings.connect(save_settings)
	openSettingsMenu.connect(open_settings_menu)


"""
--- Runtime Methods
"""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

"""
--- Custom Methods
"""

func create_new_config() -> ConfigFile:
	var newConfig = ConfigFile.new()
	newConfig = get_default_config_file(newConfig)
	newConfig.save("user://config.cfg")
	return newConfig

func get_default_config_file(config: ConfigFile) -> ConfigFile:
	config.load("res://scripts/settings/default_config.cfg")
	return config
	
func open_settings_menu() -> void:
	var menu = preloadSettingsMenu.instantiate()
	get_tree().current_scene.add_child(menu)
	menu.layer = 100
	Signals.emit_signal("menu_clear")
	
func save_settings() -> void:
	config.save("user://config.cfg")
	
func check_config_file_integrity() -> bool:
	var default_config_file:ConfigFile = ConfigFile.new()
	default_config_file.load("res://scripts/settings/default_config.cfg")
	for section in default_config_file.get_sections():
		for key in default_config_file.get_section_keys(section):
			if not config.has_section_key(section,key):
				printerr("Config file intergry fault at section:"+ section +" and key:" + key+". Reseting to default settings.")
				return false
	return true
	
func update_settings() -> void:
	if not check_config_file_integrity():
		config = create_new_config()
	update_gameplay()
	update_graphics()
	update_audio()
	
func update_gameplay() -> void:
	var toRetranslate: bool = false
	if TranslationServer.get_locale() != config.get_value("Gameplay", "Language"):
		toRetranslate = true
	TranslationServer.set_locale(config.get_value("Gameplay", "Language"))
	if toRetranslate:
		emit_signal("retranslate")
	
func update_graphics() -> void:
	DisplayServer.window_set_mode(config.get_value("Graphics", "ScreenMode"))
	# Sets window resolution
	DisplayServer.window_set_size(config.get_value("Graphics", "Resolution"))
	# If window mode windowed is selected it repositions the window into the middle of the screen
	if config.get_value("Graphics", "ScreenMode") == 0:
		DisplayServer.window_set_position(DisplayServer.screen_get_size()/2-DisplayServer.window_get_size()/Vector2i(2.0,4.0))
	DisplayServer.window_set_vsync_mode(config.get_value("Graphics", "Vsync"))

func update_audio() -> void:
	for bus in config.get_section_keys("AudioVolume"):
		AudioManager.set_bus_volume(AudioManager.get_bus_enum(bus),config.get_value("AudioVolume", bus))
