class_name MainMenuControl extends Control

@export_range(0.0,5.0,0.1) var fadeInTimeout: float = 0.5
@export_range(0.0,5.0,0.1) var fadeInDuration: float = 0.5

var profileMirror: Dictionary = {}
var selectedProfile: ProfileResource

"""
--- Setup functions
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fade_in_intro()
	%MainMenuControl.visible = true
	modulate = Color.TRANSPARENT
	Signals.s_MenuAnimationFinished.connect(fade_in)
	Signals.s_MenuAnimationFinished.connect(setup_notifications)
	
	PersistenceController.s_SceneLoaded.emit()
	GameController.s_ProfileLoaded.connect(setup_menu)
	SettingsController.s_Retranslate.connect(setup_menu)
	
	%TestSceneButton.grab_focus()
	
	setup_menu()

func setup_notifications() -> void:
	if SettingsController.get_setting("Profile", "SkipIntro") == 0:
		SettingsController.set_setting("Profile", "SkipIntro", 1)
		%NotificationConfirmation.popup()
	elif not GameController.profile:
		%ProfileCreationConfirmation.popup()

func fade_in_intro() -> void:
	await get_tree().create_timer(0.5).timeout
	await GameController.fade_to_color(%FadeInBackground,Color.TRANSPARENT,1.5)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event.is_action_pressed("interact") or event.is_action_pressed("ui_menu"):
		fade_in(true)

func fade_in(skip: bool = false) -> void:
	if not skip:
		await get_tree().create_timer(fadeInTimeout).timeout
	GameController.fade_to_color(self,Color.WHITE,fadeInDuration)

#region Main Actions Managment and Signal Methods
func _on_test_scene_button_pressed() -> void:
	GameController.change_scene("test_level")

func _on_load_button_pressed() -> void:
	PersistenceController.s_PersistenceMenuOpen.emit(PersistenceMenu.e_Mode.LOAD)

func _on_achievements_button_pressed() -> void:
	%AchievementsFlair.visible = false
	GameController.s_AchievementsMenuOpen.emit()

func _on_settings_button_pressed() -> void:
	SettingsController.s_SettingsMenuOpen.emit()
	
func _on_quit_button_pressed() -> void:
	GameController.quit_game()
#endregion

#region Profile Managemnt Methods
func setup_menu() -> void:#
	setup_profile_information()
	
	var profileActive: bool = false
	if GameController.profile:
		profileActive = true
	
	setup_controls_profile(profileActive)
	setup_controls_achievements(profileActive)
	setup_controls_persistence(profileActive)

func setup_profile_information() -> void:
	var profiles: Dictionary = ProfileResource.get_available_profile_dict()
	if profiles.is_empty():
		%ChooseProfileButton.disabled = true
	else:
		%ChooseProfileButton.disabled = false
		setup_profile_mirror(profiles)
		setup_profile_list()

func setup_profile_mirror(profiles: Dictionary) -> void:
	profileMirror.clear()
	for id in profiles.keys():
		profileMirror[profiles[id].profileName] = profiles[id]

func setup_profile_list() -> void:
	%ProfilesList.clear()
	%ProfilesList.reset_size()
	for id in profileMirror.keys():
		%ProfilesList.add_item(profileMirror[id].profileName)

func setup_controls_profile(active: bool) -> void:
	if active:
		%ProfileLabel.text = "[font_size=20][color=#%s]%s\n[/color][font_size=28][color=#%s]%s[/color]" % [Global.color_White.to_html(),tr("PROFILE_LABEL"),Global.color_TextHighlight.to_html(),GameController.profile.profileName]
	else:
		%ProfileLabel.text = "[color=RED]%s" % tr("PROFILE_MISSING_LABEL")
	
	var tip: String = "PROFILE_REQUIRED_TOOLTIP"
	if active:
		tip = ""
	
	%TestSceneButton.tooltip_text = tip
	%AchievementsButton.tooltip_text = tip
	%LoadButton.tooltip_text = tip
	%TestSceneButton.disabled = not active
	%AchievementsButton.disabled = not active
	%LoadButton.disabled = not active
	
func setup_controls_achievements(active: bool) -> void:
	if active:
		if not GameController.profile.achievements:
			return
		if GameController.profile.achievements.get_new_achievements_count() > 0:
			%AchievementsFlair.visible = true

func setup_controls_persistence(active: bool) -> void:
	if not active:
		return
	
	var tip: String = "PROFILE_NO_SAVEFILES_TOOLTIP"
	var state: bool = true
	if PersistenceController.get_profile_savefile_count(GameController.profile.id) > 0:
		tip = ""
		state = false
	
	%LoadButton.tooltip_text = tip
	%LoadButton.disabled = state

func create_profile() -> void:
	if %ProfileCreationLineEdit.text == "":
		GameController.play_quick_text_effect_error("ERROR_PROFILE_NAME_EMPTY")
		%ProfileCreationLineEdit.grab_click_focus()
		return
	
	if check_profile_exists(%ProfileCreationLineEdit.text):
		GameController.play_quick_text_effect_error("ERROR_PROFILE_EXISTS")
		%ProfileCreationLineEdit.clear()
		%ProfileCreationLineEdit.grab_click_focus()
		return
	
	var newProfileName: String = %ProfileCreationLineEdit.text
	%ProfileCreationConfirmation.hide()
	%ProfileCreationLineEdit.clear()
	GameController.create_set_save_new_profile(newProfileName)
	setup_menu()
	

func check_profile_exists(newProfileName: String) -> bool:
	var newID = ProfileResource.create_id(newProfileName)
	if newID in profileMirror:
		return true
	return false

#endregion

#region Control Signal Methods
func _on_choose_profile_button_pressed() -> void:
	%ProfileSelectionWindow.popup()

func _on_profiles_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	selectedProfile = profileMirror[%ProfilesList.get_item_text(index)] 
	if mouse_button_index == MOUSE_BUTTON_LEFT:
		GameController.set_profile(selectedProfile)
		%ProfileSelectionWindow.hide()
	elif mouse_button_index == MOUSE_BUTTON_RIGHT:
		%ProfileDeletionConfirmation.dialog_text = "%s\n%s" % [tr("PROFILE_DELETION_CONFIRMATION"),selectedProfile.profileName]
		%ProfileDeletionConfirmation.popup()

func _on_profile_deletion_confirmation_canceled() -> void:	
	%ProfileSelectionWindow.hide()

func _on_profile_deletion_confirmation_confirmed() -> void:
	%ProfileSelectionWindow.hide()
	GameController.delete_profile(selectedProfile.id)

func _on_create_profile_button_pressed() -> void:
	%ProfileCreationLineEdit.grab_click_focus()
	%ProfileCreationConfirmation.popup()

func _on_profile_creation_confirmation_confirmed() -> void:
	create_profile()

func _on_profile_creation_line_edit_text_submitted(new_text: String) -> void:
	create_profile()

func _on_focus_entered() -> void:
	%TestSceneButton.grab_focus()
#endregion
