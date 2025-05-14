class_name TextObjectResourse extends Resource

"""
--- Text Object Enum
"""
enum textTypeEnum {PAPER,BOOK,PDF,NOTE}

"""
--- Text Resourses
"""
@export_category("Text Information")
@export var textName: String = ""
@export var textType: textTypeEnum = textTypeEnum.PAPER

@export_category("Text Contents")
@export var textContents: String = ""
