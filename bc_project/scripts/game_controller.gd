extends Node

#region Veriables, Constants, Preloads, Enums
#region Preload Scene Constants

const preloadInGameMenu = preload("res://scenes/menus/ingame_menu.tscn")
const preloadDetectiveBoardMenu = preload("res://scenes/UI/board/detective_board.tscn")
const preloadMainOverlay = preload("res://scenes/UI/overlay/main_overlay.tscn")
const preloadInputHelp = preload("res://scenes/UI/overlay/input_help_overlay.tscn")
const preloadCameraControls = preload("res://scenes/cameraControls/camera_controls.tscn")
const preloadAchievementsMenu = preload("res://scripts/profile/achievements_menu.tscn")
const prelaodGameOverScreen = preload("res://scenes/gameOver/game_over_screen.tscn")
#endregion

#region Preload ScreenEffects scenes, Enums and Constants

const preloadScreenTextEffect = preload("res://scenes/screenEffects/screen_text_effect.tscn")

const preloadTimelineShiftEffect = preload("res://scenes/screenEffects/timeline_shift_effect.tscn")
const preloadFadeInEffect = preload("res://scenes/screenEffects/fade_in_effect.tscn")
const preloadFadeOutEffect = preload("res://scenes/screenEffects/fade_out_effect.tscn")

enum screenEffectEnum {TIMELINE_SHIFT,FADE_IN,FADE_OUT}
const screenEffects: Dictionary = {
	screenEffectEnum.TIMELINE_SHIFT : preloadTimelineShiftEffect,
	screenEffectEnum.FADE_IN: preloadFadeInEffect,
	screenEffectEnum.FADE_OUT: preloadFadeOutEffect,
}
#endregion

#region Profile and  Saves Variables and Constants
var profile: ProfileResource
#endregion

#region Signals
signal profileCreate(profileName)
signal profileSet(profile)
signal profileLoaded()

signal openAchievementsMenu()
signal setAchievement(type)

signal setMainOverlayVisibility(state)

signal playScreenEffect(effect)

# Signals for updating player overlay
signal sceneLoaded()
signal gameLoaded()

signal gameOver(type)
#endregion

#region Runtime Variables
# Flag for if focus is set
var FocusSet:bool = false

var sceneToLoad:String = ""

# Node for further control over overlays
var mainOverlay: Node
var inputHelp: Node
var detectiveBoard: Node
var cameraControls: Node
var achievementsMenu: AchievementsMenu 
#endregion
#endregion

#region Setup Methods
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Added group tag for persistence purposes
	add_to_group("Persistent")
	
	# Connecting signals
	get_viewport().gui_focus_changed.connect(_on_focus_changed)
	get_viewport().tree_exiting.connect(save_profile)
	
	setMainOverlayVisibility.connect(set_main_overlay_visibility)
	playScreenEffect.connect(play_screen_effect)
	
	profileCreate.connect(create_set_save_new_profile)
	profileSet.connect(set_profile)
	
	setAchievement.connect(set_achievement)
	openAchievementsMenu.connect(open_achievements_menu)
	
	gameOver.connect(game_over)
	
	sceneLoaded.connect(play_fade_in_effect)
	sceneLoaded.connect(setup_camera_controls)
	sceneLoaded.connect(setup_main_overlay_menu)
	sceneLoaded.connect(setup_input_help_menu)
	sceneLoaded.connect(setup_detective_board_menu)
	
	DialogueManager.connect("dialogue_ended",release_focus)
	DialogueManager.connect("got_dialogue",dialogue_voice_check)
	
	
	load_config_profile()

#endregion

#region Runtime Methods
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_menu"):
		open_ingame_menu()
		get_viewport().set_input_as_handled()
#endregion

#region Game Managment Methods
func quit_game() -> void:
	save_profile()
	get_tree().quit(0)

func game_over(type: GameOverResource.type) -> void:
	var gameOverScreen: GameOverScreen = prelaodGameOverScreen.instantiate()
	gameOverScreen.info = GameOverResource.info[type]
	get_tree().current_scene.add_child(gameOverScreen)
#endregion

#region Profile Methods
func load_config_profile() -> void:
	Global.check_create_directory(ProfileResource.folderPath)
	var id: String = SettingsController.get_profile_id()
	if id == "":
		return
	load_profile(id)

func load_profile(id: String) -> void:
	var profilePath = ProfileResource.create_filepath_id(id)
	if not Global.check_file_exists(profilePath):
		printerr("Error: Profile ID '%s' saved in config doesn't have existing profile resource file" % id)
		return
	load_profile_from_path(profilePath)
	
func load_profile_from_path(filepath: String) -> void:
	profile = ResourceLoader.load(filepath)
	profileLoaded.emit()

func save_profile() -> void:
	if profile:
		profile.save()

func set_profile(_profile: ProfileResource) -> void:
	profile = _profile
	SettingsController.set_profile_id(profile.id)
	profileLoaded.emit()

func clear_profile():
	profile = null
	profileLoaded.emit()

func delete_profile(_id: String):
	if profile:
		if profile.id == _id:
			clear_profile()
	var profiles: Dictionary = ProfileResource.get_available_profile_dict()
	if profiles.has(_id):
		PersistenceController.deleteProfileSavefiles.emit(_id)
		profiles[_id].delete()
	profileLoaded.emit()


func create_save_new_profile(_profileName) -> void:
	var newProfile: ProfileResource = create_new_profile(_profileName)
	newProfile.save()

func create_set_save_new_profile(_profileName) -> void:
	set_profile(create_new_profile(_profileName))
	profile.save()

func create_new_profile(_profileName: String) -> ProfileResource:
	var newProfile: ProfileResource = ProfileResource.new()
	newProfile.setup(_profileName)
	return newProfile

func get_profile_seed() -> int:
	if profile:
		return profile.seed
	return 000000

#endregion

#region Achievements Methods
func open_achievements_menu() -> void:
	achievementsMenu = preloadAchievementsMenu.instantiate()
	var loadPopupMenu = load("res://scenes/menus/popup_menu_controller.tscn")
	var popupMenu: PopupMenuController = loadPopupMenu.instantiate()
	achievementsMenu.profile = profile
	get_tree().current_scene.add_child(popupMenu)
	popupMenu.setup(achievementsMenu)
	popupMenu.popup.emit()
	Signals.emit_signal("menu_clear")

func set_achievement(_type: AchievementsResource.type) -> void:
	profile.achievements.set_achievement(_type)

#endregion

#region Global Minsc Methods
func multiply_string(input:String,times:int) -> String:
	var output: String = ""
	for idx in range(times):
		output = output + input
	return output

func change_scene(sceneName:String) -> bool:
	sceneToLoad = Global.scenePaths[sceneName]
	if sceneToLoad:
		Global.currentScene = sceneName
		get_tree().change_scene_to_packed(load("res://scenes/menus/loading_screen.tscn"))
		return true
	return false
	
# Checks if the currecnt scene is a nongameplay one
# Return true if yes and false if not
func check_nongameplay_scene() -> bool:
	var current_scene_name = get_tree().current_scene.name
	if current_scene_name in Global.nongameplayScenes:
		return true
	return false

# Returns number of keys bound to input map
func get_input_key_count(inputName: String) -> int:
	if InputMap.has_action(inputName):
		return InputMap.action_get_events(inputName).size()
	return -1

func find_node_by_name_in_array(nodeArray: Array, nodeName: String) -> Node:
	for node in nodeArray:
		if node is Node:
			if node.name == nodeName:
				return node
	printerr("Error: Could not find node %s in array %s" % [nodeName,nodeArray])
	return null
#endregion

#region Input Key Methods
# Returns key bound to input map by index
# Default index is 0
func get_input_key(inputName: String, index: int = 0) -> String:
	if InputMap.has_action(inputName):
		var output = InputMap.action_get_events(inputName)[index].as_text()
		output = output.split("(")[0]
		output = output.split("-")[0]
		output = output.strip_edges()
		if output.contains(" "):
			output = create_inintials_from_string(output)
		return output
	printerr("No input key found during method get_input_key")
	return "null"

func create_inintials_from_string(input: String) -> String:
	if not input:
		printerr("No input given to the create_inintials_from_string method")
		return ""
	var output: String = ""
	for word in input.split(" "):
		output = output + word[0]
	return output

# Returns all keys bound to input map in an array
func get_input_key_list(inputName: String) -> Array:
	var output: Array[String] = []
	for x in range(get_input_key_count(inputName)):
		output.append(get_input_key(inputName,x))
	return output
#endregion

#region Focus Methods
# Called if focus has been set
func _on_focus_changed(control:Control) -> void:
	if control:
		FocusSet = true

# Called if focus has been set
func check_release_focus() -> bool:
	if FocusSet:
		release_focus()
		return true
	return false

# Can be called to reset focus
func release_focus(resource = null) -> void:
	if FocusSet:
		get_viewport().gui_release_focus()
		FocusSet = false
#endregion

#region Camera Constrols Methods
# Instantiates and shows the in-game menu
func setup_camera_controls() -> void:
	# Checks if the scene name is in the nongameplay scenes
	# If the scene is a non gameplay one this menu cannot open
	if check_nongameplay_scene():
		return
	cameraControls = preloadCameraControls.instantiate()
	cameraControls.position = get_tree().get_first_node_in_group("Player").position
	get_tree().current_scene.add_child(cameraControls)
#endregion

#region Detective Board Methods
# Instantiates and shows the in-game menu
func setup_detective_board_menu() -> void:
	# Checks if the scene name is in the nongameplay scenes
	# If the scene is a non gameplay one this menu cannot open
	if check_nongameplay_scene():
		return
	detectiveBoard = preloadDetectiveBoardMenu.instantiate()
	mainOverlay.add_child(detectiveBoard)
	detectiveBoard.visible = false
#endregion

#region Screen Effects Methods
func play_screen_effect(_effect: screenEffectEnum) -> void:
	var screenEffect = screenEffects[_effect].instantiate()
	get_tree().current_scene.add_child.call_deferred(screenEffect)
	screenEffect.visible = true


func play_fade_in_effect() -> void:
	if not GameController.check_nongameplay_scene():
		play_screen_effect(screenEffectEnum.FADE_IN)
	
func play_screen_text_effect(_input: String, _lineTimeout: float = 0.1, _characterTimeout: float = 0.06, _finishTimeout: float = 3.0) -> void:
	var effect: ScreenTextEffect = preloadScreenTextEffect.instantiate()
	effect.input = _input
	effect.lineTimeout = _lineTimeout
	effect.characterTimeout = _characterTimeout
	effect.finishTimeout = _finishTimeout
	get_tree().current_scene.add_child(effect)
	effect.visible = true

## Overrides [peram node] [memeber node.material] with a fade object shader. [br]
## Sets starting and ending alpha value based on [param start] paramenter. [br]
## Through tween fades [CanvasItem] object to desired aplha value (fade in/out).
func fade_object(node : CanvasItem, start: float = 1.0) -> bool:
	## Constraints the input with a range of 0.0-1.0
	var constrainedStart: float = min(1.0,max(0.0,start))
	
	## Overrides input [param node] [CanvasItem] material with a fade object shader and sets the start aplha value
	var overrideShader = ShaderMaterial.new()
	overrideShader.shader = load("res://shaders/fade_object.gdshader")
	node.material = overrideShader
	node.material.set("shader_parameter/value",constrainedStart)
	
	## Creates a tween, connects it with the shader and then waits till until tween finishes
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(node.material,"shader_parameter/value",1.0-constrainedStart,0.5).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	
	## Returns true for possible await
	return true
	


func fade_to_color(item: CanvasItem, color: Color, duration: float = 0.3) -> bool:
	var tween: Tween = create_tween()
	if not is_inside_tree():
		return false
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(item,"modulate", color, duration)
	await tween.finished
	tween.kill()
	return true
#endregion

#region Overlay Methods
# Instantiates and shows the in-game menu
func setup_main_overlay_menu() -> void:
	# Checks if the scene name is in the nongameplay scenes
	# If the scene is a non gameplay one this menu cannot open
	if check_nongameplay_scene():
		return
	mainOverlay = preloadMainOverlay.instantiate()
	get_tree().current_scene.add_child(mainOverlay)
	mainOverlay.layer = 50
	mainOverlay.visible = true

# Instantiates and shows the in-game menu
func setup_input_help_menu() -> void:
	# Checks if the scene name is in the nongameplay scenes
	# If the scene is a non gameplay one this menu cannot open
	if check_nongameplay_scene():
		return
	inputHelp = preloadInputHelp.instantiate()
	mainOverlay.add_child(inputHelp)
	inputHelp.visible = true

func set_main_overlay_visibility(state: bool) -> void:
	mainOverlay.visibility = state
#endregion

#region In-game Menu Methods
# Instantiates and shows the in-game menu
func open_ingame_menu() -> void:
	# Checks if the scene name or filename is in the nongameplay scenes
	# If the scene is a non gameplay one this menu cannot open
	if check_nongameplay_scene():
		return
	var menu = preloadInGameMenu.instantiate()
	get_tree().current_scene.add_child(menu)
	menu.layer = 90
	menu.visible = true
	Signals.emit_signal("menu_clear")
#endregion

#region Dialogue Voice Acting Methods
func dialogue_voice_check(line: DialogueLine) -> void:
	if line.translation_key:
		AudioManager.play_dialogue("dialogue/"+line.translation_key)
#endregion

#region Persistence Methods
"""
--- Persistence Methods
"""
func saving() -> Dictionary:
	var output: Dictionary = {
		"persistent": true,
		"nodepath": get_path(),
		"parent": get_parent().get_path(),
	}
	return output

func loading(input: Dictionary) -> bool:
	return true
#endregion
