extends Node

"""
--- Gloabal Signals
"""

signal configReady

signal updateSettings
signal saveSettings

signal openSettingsMenu

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
	newConfig = set_default_config(newConfig)
	newConfig.save("user://config.cfg")
	return newConfig

func set_default_config(config: ConfigFile) -> ConfigFile:
	config.load("res://scripts/settings/default_config.cfg")
	return config
	
func open_settings_menu() -> void:
	var menu = preloadSettingsMenu.instantiate()
	get_tree().current_scene.add_child(menu)
	menu.layer = 100
	print(menu.get_parent())
	
func save_settings() -> void:
	config.save("user://config.cfg")
	
func update_settings() -> void:
	update_graphics()
	update_audio()
	
func update_graphics() -> void:
	if config.has_section_key("Graphics", "ScreenMode"):
		DisplayServer.window_set_mode(config.get_value("Graphics", "ScreenMode"))
	if config.has_section_key("Graphics", "Resolution"):
		DisplayServer.window_set_size(config.get_value("Graphics", "Resolution"))
	if config.has_section_key("Graphics", "Vsync"):
		DisplayServer.window_set_vsync_mode(config.get_value("Graphics", "Vsync"))

func update_audio() -> void:
	for bus in config.get_section_keys("AudioVolume"):
		AudioManager.set_bus_volume(AudioManager.get_bus_enum(bus),config.get_value("AudioVolume", bus))
