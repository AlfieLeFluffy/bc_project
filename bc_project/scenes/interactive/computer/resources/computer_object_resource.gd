class_name ComputerObjectResource extends Resource

"""
--- Computer Object Enum
"""
enum computerTypeEnum {COMPUTER,TABLET}

"""
--- Computer Resourses
"""
@export_group("Computer Information")
@export var name: String = ""
@export var type: computerTypeEnum = computerTypeEnum.COMPUTER
@export var state: bool = true

@export_group("Login Information")
@export var login: bool = false
@export var locked: bool = false
@export var password: String = ""
