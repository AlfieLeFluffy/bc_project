class_name UserResource extends Resource

@export_group("User Information")
@export var username:String
@export var password:String

func check_password(_password: String) -> bool:
	if password.strip_edges().strip_escapes() == _password.strip_edges().strip_escapes():
		return true
	return false
