class_name ComputerObjectResource extends Resource

"""
--- Text Object Enum
"""
enum computerTypeEnum {COMPUTER,TABLET}

"""
--- Text Resourses
"""
@export_category("Text Information")
@export var computerName: String = ""
@export var computerType: computerTypeEnum = computerTypeEnum.COMPUTER
@export var computerState: bool = true
