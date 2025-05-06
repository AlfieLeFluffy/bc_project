extends Node

#region Veriables, Constants, Preloads, Enums
#region Preload Scene Constants
## A constant containing a preloaded scene of [LoadinScreen]
const preloaded_LoadingScreen = preload("res://scenes/menus/loading_screen.tscn")
## A constant containing a preloaded scene of [InGameMenu]
const preloaded_InGameMenu = preload("res://scenes/menus/ingame_menu.tscn")
## A constant containing a preloaded scene of [DetectiveBoardMenu]
const preloaded_DetectiveBoardMenu = preload("res://scenes/UI/board/detective_board.tscn")
## A constant containing a preloaded scene of [MainOverlay]
const preloaded_MainOverlay = preload("res://scenes/UI/overlay/main_overlay.tscn")
## A constant containing a preloaded scene of [InputHelp]
const preloaded_InputHelp = preload("res://scenes/UI/overlay/input_help_overlay.tscn")
## A constant containing a preloaded scene of [CameraControls]
const preloaded_CameraControls = preload("res://scenes/cameraControls/camera_controls.tscn")
## A constant containing a preloaded scene of [AchievementsMenu]
const preloaded_AchievementsMenu = preload("res://scripts/profile/achievements_menu.tscn")
## A constant containing a preloaded scene of [GameOverScreen]
const preloaded_GameOverScreen = preload("res://scenes/gameOver/game_over_screen.tscn")
## A constant containing a preloaded scene of [PopupMenuController]
const preloaded_PopupMenuController = preload("res://scenes/menus/popup_menu_controller.tscn")
#endregion

#region Preload ScreenEffects scenes, Enums and Constants
## A constant containing a preloaded scene of a screen effect [ScreenTextEffect]
const preloaded_ScreenTextEffect = preload("res://scenes/screenEffects/screen_text_effect.tscn")
## A constant containing a preloaded scene of a screen effect [TimelineShiftEffect]
const preloaded_TimelineShiftEffect = preload("res://scenes/screenEffects/timeline_shift_effect.tscn")
## A constant containing a preloaded scene of a screen effect [FadeInEffect]
const preloaded_FadeInEffect = preload("res://scenes/screenEffects/fade_in_effect.tscn")
## A constant containing a preloaded scene of a screen effect [FadeOutEffect]
const preloaded_FadeOutEffect = preload("res://scenes/screenEffects/fade_out_effect.tscn")

## An enum definition for the possible screen effects
enum e_ScreenEffectType {TIMELINE_SHIFT,FADE_IN,FADE_OUT}
## A constant dictionary holding the reference to the preloaded screen effects 
const SCREEN_EFFECTS_DICTIONARY: Dictionary = {
	e_ScreenEffectType.TIMELINE_SHIFT : preloaded_TimelineShiftEffect,
	e_ScreenEffectType.FADE_IN: preloaded_FadeInEffect,
	e_ScreenEffectType.FADE_OUT: preloaded_FadeOutEffect,
}
#endregion

#region Profile and  Saves Variables and Constants
## A variable holding the reference to the current active [ProfileResource]
var profile: ProfileResource
#endregion

#region Signals
## Signal used for creating a new game profile. 
## If no profile is selected during profile creation the new profile set as current.[br] 
##
## - [param newProfileName] is a name for the new profile in [String].[br]
signal s_ProfileCreate(newProfileName: String)
## Signal used for setting the current profile.[br] 
##
## - [param profile] is a reference to an instance of a [ProfileResource].[br]
signal s_ProfileSet(profile: ProfileResource)
## Signal used for notifying scripts using the current profile resource that it a new profile was loaded.[br] 
signal s_ProfileLoaded()

## Signal used to notify [GameController] autoload script to open the achievements menu.
signal s_AchievementsMenuOpen()
## Signal used to set the an achievement of [param type] as acquired for the current profile.
## If the current profile already has an achievement of [param type] acquired then nothing happens.[br]
##
## - [param type] is an enum type stored in the [AchievementsResource] refering to a specific achieveemnt.
signal s_AchievementSet(type: AchievementsResource.type)

## Signal used to set the visibility of the scene's main overlay node. [br]
##
## - [param state] is a bool parameter to which the visibility will be set.
signal s_MainOverlayVisibilitySet(state: bool)
## Signal used to trigger a screen effect to play. [br]
##
## - [param effectType] is an enum type that refering to a specific screen effect.
signal s_ScreenEffectPlay(effectType: e_ScreenEffectType)


## Signal that notifies the [GameController] autoload script that a game over trigger was reached.
## This initializes the script to set the game into a game over state (releases camera controlls, shows a game over screen, ect.)
signal s_GameOver(type: GameOverResource.type)
#endregion

#region Runtime Variables
## A variable holding a [bool] flag noting if a [Control] focus has been set.
var FocusSet: bool = false

## A variable containing the name of the scene that will be loaded. Used by the loading screen scene.
var nextSceneToLoad:String = ""

## A variable holding the [MainOverlay] scene instance
var mainOverlay: Node
## A variable holding the [InputHelp] scene instance
var inputHelp: Node
## A variable holding the [DetectiveBoard] scene instance
var detectiveBoard: Node
## A variable holding the [CameraControls] scene instance
var cameraControls: Node
## A variable holding the [AchievementsMenu] scene instance
var achievementsMenu: AchievementsMenu
## A variable holding the [GameOver] scene instance
var gameOver: GameOverScreen
#endregion
#endregion

"""
--- Setup Methods
"""
#region Setup Methods
func _ready() -> void:
	
	## Adds this autoload script into the Persistent group
	add_to_group(PersistenceController.PERSISTENCE_GLOBAL_GROUP_NAME)
	
	## Connecting viewport signals
	get_viewport().gui_focus_changed.connect(_on_focus_changed)
	get_viewport().tree_exiting.connect(save_profile)
	
	## Connecting [GameController] signals
	s_MainOverlayVisibilitySet.connect(set_main_overlay_visibility)
	s_ScreenEffectPlay.connect(play_screen_effect)
	
	s_ProfileCreate.connect(create_set_save_new_profile)
	s_ProfileSet.connect(set_profile)
	s_ProfileLoaded.connect(check_profile_setup)
	
	s_AchievementSet.connect(set_achievement)
	s_AchievementsMenuOpen.connect(open_achievements_menu)
	
	s_GameOver.connect(game_over)
	
	## Connecting [PersistenceController] signals
	PersistenceController.s_SceneLoaded.connect(play_fade_in_effect)
	PersistenceController.s_SceneLoaded.connect(setup_camera_controls)
	PersistenceController.s_SceneLoaded.connect(setup_main_overlay_menu)
	PersistenceController.s_SceneLoaded.connect(setup_input_help_menu)
	PersistenceController.s_SceneLoaded.connect(setup_detective_board_menu)
	
	## Connecting [DialogueManager] signals
	DialogueManager.connect("dialogue_ended",release_focus)
	DialogueManager.connect("got_dialogue",dialogue_voice_check)
	
	load_config_profile()

#endregion



"""
--- Runtime Methods
"""
#region Runtime Methods
## Opens in-game menu if possible
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_menu"):
		open_ingame_menu()
		get_viewport().set_input_as_handled()
#endregion



#region Game Managment Methods
## A method that quits the game. If the game is running browser this method does nothing.
func quit_game() -> void:
	save_profile()
	match OS.get_name():
		"Web":
			return
		_:
			get_tree().quit(0)

## A method that instantiates the  game over scene and sets that game into game over state.
func game_over(type: GameOverResource.type) -> void:
	if gameOver:
		return
	gameOver = preloaded_GameOverScreen.instantiate()
	gameOver.info = GameOverResource.info[type]
	get_tree().current_scene.add_child(gameOver)
#endregion



#region Profile Methods
## A method that checks existence of the profile folder path, loaded the configured profile id
## and load the current profile is one exists.
func load_config_profile() -> void:
	Global.check_create_directory(ProfileResource.folderPath)
	var id: String = SettingsController.get_profile_id()
	if id == "":
		return
	load_profile(id)

## A method that load a [ProfileResource]. [br]
##
## - [param id] is the profile ID that is supposed to be loaded.
func load_profile(id: String) -> void:
	var profilePath = ProfileResource.create_filepath_id(id)
	if not Global.check_file_exists(profilePath):
		printerr("Error: Profile ID '%s' saved in config doesn't have existing profile resource file" % id)
		return
	load_profile_from_path(profilePath)

## A method that loaded a profile from a filepath. [br]
##
## - [param filepath] the file path from which the profile should be laoded.
func load_profile_from_path(filepath: String) -> void:
	profile = ResourceLoader.load(filepath)
	s_ProfileLoaded.emit()

## A method that save the current profile.
func save_profile() -> void:
	if profile:
		profile.save()

## A method that emits a signal to check if a profile has a savefile folder setup.
func check_profile_setup() -> void:
	PersistenceController.s_CheckProfileSavefileFolder.emit(profile.id)

## A method that sets a current profile to another profile. [br]
##
## - [param _profile] is the [ProfileResource] that should replace the current one.
func set_profile(_profile: ProfileResource) -> void:
	profile = _profile
	SettingsController.set_profile_id(profile.id)
	s_ProfileLoaded.emit()

## A method that clears the current profile.
func clear_profile():
	profile = null
	s_ProfileLoaded.emit()

## A method that deletes a profile by profile ID. This also deletes all savefile attaached to the profile[br]
##
## - [param _id] is the profile ID of the [ProfileResource] that should be deleted.
func delete_profile(_id: String):
	if profile:
		if profile.id == _id:
			clear_profile()
	var profiles: Dictionary = ProfileResource.get_available_profile_dict()
	if profiles.has(_id):
		PersistenceController.s_SavefilesProfileDelete.emit(_id)
		profiles[_id].delete()
	s_ProfileLoaded.emit()

## A method creates and saves a new profile. [br]
##
## - [param _profileName] is the name that the new [ProfileResource] should use.
func create_save_new_profile(_profileName) -> void:
	var newProfile: ProfileResource = create_new_profile(_profileName)
	newProfile.save()

## A method creates, saves and sets a new profile as the current one. [br]
##
## - [param _profileName] is the name that the new [ProfileResource] should use.
func create_set_save_new_profile(_profileName) -> void:
	set_profile(create_new_profile(_profileName))
	profile.save()

## A method creates a new profile. [br]
##
## - [param _profileName] is the name that the new [ProfileResource] should use.
func create_new_profile(_profileName: String) -> ProfileResource:
	var newProfile: ProfileResource = ProfileResource.new()
	newProfile.setup(_profileName)
	return newProfile

## A method finds and return the seed of the current profile. [br]
func get_profile_seed() -> int:
	if profile:
		return profile.seed
	printerr("Error: While getting profile ID, no profile selected.")
	return 000000

## A method finds and return the ID of the current profile. [br]
func get_profile_id() -> String:
	if profile:
		return profile.id
	printerr("Error: While getting profile ID, no profile selected.")
	return ""

#endregion



#region Achievements Methods
## A method that instantiates and opens the [AchievementsMenu]
func open_achievements_menu() -> void:
	achievementsMenu = preloaded_AchievementsMenu.instantiate()
	achievementsMenu.profile = profile
	open_popup_menu(achievementsMenu)

## A method that sets achievement for the current profile if a current profile is set.
func set_achievement(_type: AchievementsResource.type) -> void:
	if not profile:
		return
	if not profile.achievements:
		return
	profile.achievements.set_achievement(_type)

#endregion



#region Global Minsc Methods
## A method that instantiates a [PopupMenuController] and uses it to display another menu. [br]
##
## - [param scene] is a [Node] that should contain the menu.
func open_popup_menu(scene: Node) -> Node:
	var popupMenu: PopupMenuController = preloaded_PopupMenuController.instantiate()
	get_tree().current_scene.add_child(popupMenu)
	popupMenu.setup(scene)
	popupMenu.popup.emit()
	return popupMenu

## A method that returns a string made from specified number of repetitions of another string. [br]
##
## - [param input] is a [String] parameter that should be multiplied. [br]
## - [param times] is a [int] parameter of how many times it should be repeated. [br]
func multiply_string(input: String, times: int) -> String:
	var output: String = ""
	for idx in range(times):
		output = output + input
	return output

## A method that return the current name of the scene.
func get_current_scene() -> String:
	return Global.currentScene

## A method sets up the next scene to be loaded and then calls for a loading scene change. [br]
##
## - [param sceneName] is a [String] name of the scene to be loaded. [br]
func change_scene(sceneName:String) -> bool:
	nextSceneToLoad = Global.SCENE_PATHS[sceneName]
	if nextSceneToLoad:
		Global.currentScene = sceneName
		get_tree().change_scene_to_packed(preloaded_LoadingScreen)
		return true
	return false

## A method that changes the scene to the next without a loading screen. [br]
##
## - [param sceneName] is a [String] name of the scene to be loaded. [br]
func change_scene_no_load(sceneName:String) -> bool:
	nextSceneToLoad = Global.scenePaths[sceneName]
	if nextSceneToLoad:
		Global.currentScene = sceneName
		get_tree().change_scene_to_packed(load(nextSceneToLoad))
		return true
	return false
	
## A method that checks if the current scene is a gameplay scene or not.
func check_nongameplay_scene() -> bool:
	var current_scene_name = get_tree().current_scene.name
	if current_scene_name in Global.NON_GAMEPLAY_SCENE_NAMES:
		return true
	return false

## A method that searches through an array and return a node by name. [br]
##
## - [param nodeArray] is an array of node. [br]
## - [param nodeName] is the name of the node searched for. [br]
func find_node_by_name_in_array(nodeArray: Array, nodeName: String) -> Node:
	for node in nodeArray:
		if node is Node:
			if node.name == nodeName:
				return node
	printerr("Error: Could not find node %s in array %s" % [nodeName,nodeArray])
	return null

## A method that return a initials from a given [String] input. [br]
##
## - [param input] is a [String] input. [br]
func create_inintials_from_string(input: String) -> String:
	if not input:
		printerr("No input given to the create_inintials_from_string method")
		return ""
	var output: String = ""
	for word in input.split(" "):
		output = output + word[0]
	return output
#endregion



#region Input Key Methods
## A method that returns the amount of input options for one input. [br]
##
## - [param inputName] is the name of the input in question.
func get_input_key_count(inputName: String) -> int:
	if InputMap.has_action(inputName):
		return InputMap.action_get_events(inputName).size()
	return -1

## A method that return a simplified [String] version of an input key from an input map. [br]
##
## - [param inputName] is the name of the input in question. [br]
## - [param index] is the position in the input map read. By defualt the first input is read. [br]
func get_input_key(inputName: String, index: int = 0) -> String:
	if not InputMap.has_action(inputName):
		printerr("No input key found during method get_input_key")
		return "null"
	var output = InputMap.action_get_events(inputName)[index].as_text()
	output = output.split("(")[0]
	output = output.split("-")[0]
	output = output.strip_edges()
	if output.contains(" "):
		output = create_inintials_from_string(output)
	return output

## A method return an array of all possible input keys for one mapped input. [br]
##
## - [param inputName] is the name of the input in question. [br]
func get_input_key_list(inputName: String) -> Array:
	var output: Array[String] = []
	for x in range(get_input_key_count(inputName)):
		output.append(get_input_key(inputName,x))
	return output
#endregion



#region Focus Methods
## A method that sets the [param FocusSet] flag if a focus is set. [br]
##
## - [param control] is a [Control] node that grabbed the focus. [br]
func _on_focus_changed(control: Control) -> void:
	if control:
		FocusSet = true

## A method that checks if a focus is set. If the focus is set it releases it and return true. 
## If not the method returns false.
func check_release_focus() -> bool:
	if FocusSet:
		release_focus()
		return true
	return false

## A method that releases the current focus and resets the [param FocusSet] flag. 
func release_focus(resource = null) -> void:
	if FocusSet:
		get_viewport().gui_release_focus()
		FocusSet = false
#endregion



#region Camera Constrols Methods
## A method that sets up the [CameraControls] in a gameplay scene.
func setup_camera_controls() -> void:
	if check_nongameplay_scene():
		return
	cameraControls = preloaded_CameraControls.instantiate()
	cameraControls.position = get_tree().get_first_node_in_group("Player").position
	get_tree().current_scene.add_child(cameraControls)
#endregion



#region Detective Board Methods
## A method that instantiates the [DetectiveBoard] scene in a gameplay scene.
func setup_detective_board_menu() -> void:
	if check_nongameplay_scene():
		return
	detectiveBoard = preloaded_DetectiveBoardMenu.instantiate()
	mainOverlay.add_child(detectiveBoard)
	detectiveBoard.visible = false
#endregion

#region Screen Effects Methods
## A method that playes a screen effect. [br]
##
## - [param _effect] is the enum type of screen effect that should be played.
func play_screen_effect(_effect: e_ScreenEffectType) -> void:
	var screenEffect = SCREEN_EFFECTS_DICTIONARY[_effect].instantiate()
	get_tree().current_scene.add_child.call_deferred(screenEffect)
	screenEffect.visible = true

## A method that playes the [FadeInEffect] in a gameplay scene.
func play_fade_in_effect() -> void:
	if not GameController.check_nongameplay_scene():
		play_screen_effect(e_ScreenEffectType.FADE_IN)

## A method that specifically plays the [ScreenTextEffect] screen effect with all its parameters. [br]
func play_screen_text_effect(_input: String, _lineTimeout: float = 0.1, _characterTimeout: float = 0.06, _finishTimeout: float = 3.0) -> void:
	var effect: ScreenTextEffect = preloaded_ScreenTextEffect.instantiate()
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

## A method that changes a [CanvasItem] modulate color over quick time. [br]
##
## - [param item] is the target [CanvasItem]. [br]
## - [param colro] is the target [Color] of the modulate. [br]
## - [param duration] is a [float] number indicating how long the fade should last. [br]
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
## A method that sets up the [MainOverlay] in a gameplay scene.
func setup_main_overlay_menu() -> void:
	if check_nongameplay_scene():
		return
	mainOverlay = preloaded_MainOverlay.instantiate()
	get_tree().current_scene.add_child(mainOverlay)
	mainOverlay.layer = 50
	mainOverlay.visible = true

## A method that sets up the [InputHelp] in a gameplay scene.
func setup_input_help_menu() -> void:
	if check_nongameplay_scene():
		return
	inputHelp = preloaded_InputHelp.instantiate()
	mainOverlay.add_child(inputHelp)
	inputHelp.visible = true

func set_main_overlay_visibility(state: bool) -> void:
	mainOverlay.visibility = state
#endregion



#region In-game Menu Methods
## A method that sets up the [InGameMenu] in a gameplay scene.
func open_ingame_menu() -> void:
	if check_nongameplay_scene():
		return
	var menu = preloaded_InGameMenu.instantiate()
	get_tree().current_scene.add_child(menu)
	menu.layer = 90
	menu.visible = true
	Signals.s_MenuClear.emit()
#endregion



#region Dialogue Voice Acting Methods
## A method that resend the dialogue line translation key to the [AudioManager] to play related dialogue. [br]
##
## - [param line] is a [DialogueLine] instance of the current dialogue line.
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
