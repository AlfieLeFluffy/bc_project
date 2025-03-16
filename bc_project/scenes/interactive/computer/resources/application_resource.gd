class_name ApplicationResource extends Resource

#region Types
enum applicationTypes {FILE_EXPLORER,COMMAND_PROMPT,TEXT_VIEW,EMAIL_CLIENT}
#endregion

#region Constant Information
const information: Dictionary = {
	ApplicationResource.applicationTypes.FILE_EXPLORER : ["FILE_EXPLORER_APPLICATION_NAME","res://textures/computer/application_icons/file_explorer_icon.png"],
	ApplicationResource.applicationTypes.COMMAND_PROMPT : ["COMMAND_PROMPT_APPLICATION_NAME", "res://textures/computer/application_icons/command_prompt_icon.png",],
	ApplicationResource.applicationTypes.TEXT_VIEW : ["TEXT_VIEW_APPLICATION_NAME","res://textures/computer/application_icons/text_viewer_icon.png",],
}
#endregion

#region Exported Variables
@export var applications: Dictionary = {
	applicationTypes.FILE_EXPLORER: true,
	applicationTypes.COMMAND_PROMPT: true,
	applicationTypes.TEXT_VIEW: true,
}

@export var activeApplications: Dictionary = {
	
}
#endregion

func clear() -> void:
	activeApplications.clear()
