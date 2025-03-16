class_name ComputerObjectResource extends Resource

#region Type
enum computerTypeEnum {COMPUTER,TABLET}
#endregion

#region Exported Varible
@export_group("Computer Information")
@export var name: String = ""
@export var type: computerTypeEnum = computerTypeEnum.COMPUTER
@export var state: bool = true

@export_group("Login Information")
@export var login: bool = false
@export var locked: bool = false
@export var currentUser: UserResource
@export var users: Array[UserResource]
#endregion

func set_current_user(resource: UserResource) -> void:
	currentUser = resource
