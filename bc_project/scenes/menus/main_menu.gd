extends Node

var profileMirror: Dictionary = {}
var selectedProfile: ProfileResource

"""
--- Setup functions
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%VersionLabel.text = tr("VERSION_LABEL") + ": " + ProjectSettings.get_setting("application/config/version")
	
	GameController.profileLoaded.connect(setup_profile)
	SettingsController.retranslate.connect(setup_profile)
	
	setup_profile()

#region Main Actions Managment and Signal Methods
func _on_test_scene_button_pressed() -> void:
	GameController.change_scene("test_level")

func _on_load_button_pressed() -> void:
	PersistenceController.emit_signal("openPersistenceMenu",PersistenceMenu.modeEnum.LOAD)

func _on_achievements_button_pressed() -> void:
	pass # Replace with function body.

func _on_settings_button_pressed() -> void:
	SettingsController.emit_signal("openSettingsMenu")
	
func _on_quit_button_pressed() -> void:
	GameController.quit_game()
#endregion

#region Profile Managemnt and Signal Methods
func setup_profile() -> void:
	var profiles: Dictionary = ProfileResource.get_available_profile_dict()
	if profiles.is_empty():
		%ChooseProfileButton.disabled = true
	else:
		profileMirror.clear()
		%ProfilesList.clear()
		for id in profiles.keys():
			profileMirror[profiles[id].profileName] = profiles[id]
			%ProfilesList.add_item(profiles[id].profileName)
	
	if not GameController.profile:
		%ProfileLabel.text = "[color=RED]%s" % tr("PROFILE_MISSING_LABEL")
		%TestSceneButton.disabled = true
		%TestSceneButton.tooltip_text = "PROFILE_REQUIRED_TOOLTIP"
		%AchievementsButton.disabled = true
		%AchievementsButton.tooltip_text = "PROFILE_REQUIRED_TOOLTIP"
		%LoadButton.tooltip_text = "PROFILE_REQUIRED_TOOLTIP"
		%LoadButton.disabled = true
		return
	
	%ProfileLabel.text = "[font_size=14][color=WEB_GRAY] %s\n [/color][font_size=24] %s" % [tr("PROFILE_LABEL"),GameController.profile.profileName]
	%TestSceneButton.disabled = false
	%TestSceneButton.tooltip_text = ""
	%AchievementsButton.disabled = false
	%AchievementsButton.tooltip_text = ""
	
	if GameController.profile:
		if PersistenceController.get_profile_savefile_count(GameController.profile.id) > 0:
			%LoadButton.tooltip_text = ""
			%LoadButton.disabled = false
		else:
			%LoadButton.tooltip_text = "PROFILE_NO_SAVEFILES_TOOLTIP"
			%LoadButton.disabled = true

func _on_choose_profile_button_pressed() -> void:
	%ProfilesList.visible = not %ProfilesList.visible

func _on_profiles_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	selectedProfile = profileMirror[%ProfilesList.get_item_text(index)] 
	if mouse_button_index == MOUSE_BUTTON_LEFT:
		GameController.set_profile(selectedProfile)
		%ProfilesList.visible = false
	elif mouse_button_index == MOUSE_BUTTON_RIGHT:
		%ProfileDeletionConfirmation.dialog_text = "%s\n%s" % [tr("PROFILE_DELETION_CONFIRMATION"),selectedProfile.profileName]
		%ProfileDeletionConfirmation.popup()

func _on_profile_deletion_confirmation_canceled() -> void:
	%ProfilesList.visible = false

func _on_profile_deletion_confirmation_confirmed() -> void:
	%ProfilesList.visible = false
	GameController.delete_profile(selectedProfile.id)

func _on_create_profile_button_pressed() -> void:
	%ProfileCreationConfirmation.popup()

func _on_profile_creation_confirmation_confirmed() -> void:
	create_profile()

func _on_profile_creation_line_edit_text_submitted(new_text: String) -> void:
	%ProfileCreationConfirmation.confirmed.emit()
	%ProfileCreationConfirmation.hide()

func create_profile() -> void:
	if %ProfileCreationLineEdit.text == "":
		return
	if not GameController.profile:
		GameController.create_set_save_new_profile(%ProfileCreationLineEdit.text)
	else:
		GameController.create_save_new_profile(%ProfileCreationLineEdit.text)
	%ProfileCreationLineEdit.text = ""
	setup_profile()
#endregion
