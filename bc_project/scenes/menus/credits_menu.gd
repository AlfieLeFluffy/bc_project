class_name CreditsMenu extends Control

const NAME_FROMAT: String = "[font_size=%s][color=#%s] %s : [color=#%s] %s"
const LINK_FROMAT: String = "[font_size=%s][color=#%s] [url=%s]%s[/url]"
const DIALOGUE_MANAGER_LINK: String = "https://github.com/nathanhoad/godot_dialogue_manager/blob/main/LICENSE"

func _ready() -> void:
	%AuthorLabel.text = NAME_FROMAT % [SettingsController.scale_font_size(24),Global.color_TextHighlight.to_html(),"Author",Global.color_TextBright.to_html(),CreditsResource.AUTHOR_NAME]
	%SupervisorLabel.text = NAME_FROMAT % [SettingsController.scale_font_size(24),Global.color_TextHighlight.to_html(),"Supervisor",Global.color_TextBright.to_html(),CreditsResource.PROJECT_SUPERVISOR_NAME]
	%DialogueManagerLabel.text = NAME_FROMAT % [SettingsController.scale_font_size(24),Global.color_TextHighlight.to_html(),"Dialogue System by",Global.color_TextBright.to_html(),"Nathan Hoad"]
	%DialogueManagerLinkLabel.text = LINK_FROMAT % [SettingsController.scale_font_size(24),Global.color_TextHighlight.to_html(),DIALOGUE_MANAGER_LINK,"License"]
