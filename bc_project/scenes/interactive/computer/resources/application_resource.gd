class_name ApplicationResource extends Resource

"""
--- Application Types
"""
enum applicationTypes {FILE_EXPLORER,COMMAND_PROMPT,TEXT_VIEW,EMAIL_CLIENT}

"""
--- Application Export
"""

@export var applications: Dictionary = {
	applicationTypes.FILE_EXPLORER: true,
	applicationTypes.COMMAND_PROMPT: true,
	applicationTypes.TEXT_VIEW: true,
}

@export var activeApplications: Dictionary = {
	
}
