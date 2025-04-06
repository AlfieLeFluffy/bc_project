class_name LoginScreen extends Control

@export var view: ComputerView

#region Setup Methods
func _ready() -> void:
	if not check_computer_view():
		return
	
	view.computer_lock.connect(lock)
	view.computer.compRes.changed.connect(setup_login_status)
	
	setup_login_status()
	if visible:
		%Account.grab_focus()
		%Account.grab_click_focus()

func setup_login_status() -> void:
	if view.computer.compRes.login:
		visible = true
	
	if not view.computer.compRes.locked:
		visible = false
	

func check_computer_view() -> bool:
	if not view:
		printerr("Error: Login screen script cannot find computer view node.")
		visible = false
		return false
	if not view.computer:
		visible = false
		printerr("Error: Login screen script cannot find computer node.")
		return false
	return true
#endregion



#region Runtime Methods
func lock() -> void:
	%Account.clear()
	%Password.clear()
	view.computer.compRes.locked = true
	visible = true

func attempt_login(username: String, password: String) -> void:
	if not check_login_info(username, password):
		%Password.clear()
		%ErrorText.visible = true
		return
	GameController.release_focus()
	view.computer.compRes.set_current_user(view.computer.usersDictionary[username])
	view.computer.compRes.locked = false
	visible = false

func check_user_exists(username: String) -> bool:
	if not view.computer.usersDictionary.has(username):
		return false
	return true

func check_login_info(username: String, password: String) -> bool:
	if not check_user_exists(username):
		return false
	if not view.computer.usersDictionary[username] is UserResource:
		return false
	if view.computer.usersDictionary[username].check_password(password):
		return true
	return false
#endregion



#region Signal Methods
func _on_login_button_pressed() -> void:
	%ErrorText.visible = false
	attempt_login(%Account.text, %Password.text)

func _on_account_text_submitted(new_text: String) -> void:
	%ErrorText.visible = false
	attempt_login(%Account.text, %Password.text)

func _on_password_text_submitted(new_text: String) -> void:
	%ErrorText.visible = false
	attempt_login(%Account.text, %Password.text)

func _on_visibility_changed() -> void:
	if visible:
		%Account.grab_focus()
#endregion
