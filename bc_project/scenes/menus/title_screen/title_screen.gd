class_name TitleScreen extends Control

var currentSlide: Slide
@export var slides: Array[Slide]

var tween: Tween
var timer: SceneTreeTimer

func _ready() -> void:
	setup_title_screen()
	run_title_screen()

func setup_title_screen() -> void:
	%WarningLabel.parse_bbcode("[font_size=%s][color=#%s]%s" % [SettingsController.scale_font_size(42),Global.color_TextHighlight.to_html(),tr("EPILEPSY_SEIZURE_WARNING_NAME")])
	%WarningText.parse_bbcode("[font_size=%s][color=#%s]%s" % [SettingsController.scale_font_size(24),Global.color_TextBright.to_html(),tr("EPILEPSY_SEIZURE_WARNING_DECSRIPTION")])

	%GodotCreditLabel.parse_bbcode("[font_size=%s][color=#%s]%s" % [SettingsController.scale_font_size(36),Global.color_TextHighlight.to_html(),tr("GODOT_CREDIT_LABEL")])
	%UniversityCreditLabel.parse_bbcode("[font_size=%s][color=#%s]%s" % [SettingsController.scale_font_size(36),Global.color_TextHighlight.to_html(),tr("VUT_CREDIT_LABEL")])

	%AuthorCreditLabel.parse_bbcode("[font_size=%s][color=#%s]%s: %s" % [SettingsController.scale_font_size(24),Global.color_TextBright.to_html(),tr("AUTHOR_CREDIT_LABEL"), CreditsResource.AUTHOR_NAME])
	%LeadCreditLabel.parse_bbcode("[font_size=%s][color=#%s]%s: %s" % [SettingsController.scale_font_size(24),Global.color_TextBright.to_html(),tr("LEAD_CREDIT_LABEL"), CreditsResource.PROJECT_SUPERVISOR_NAME])

	%AudioWarningLabel.parse_bbcode("[font_size=%s][color=#%s]%s" % [SettingsController.scale_font_size(36),Global.color_TextHighlight.to_html(),tr("AUDIO_WARNING")])
	%HeadphonesWarningLabel.parse_bbcode("[font_size=%s][color=#%s]%s" % [SettingsController.scale_font_size(24),Global.color_TextBright.to_html(),tr("HEADPHONES_WARNING")])

	%TitleAnimation.texture.pause = true
	%TitleAnimation.texture.current_frame = 0

func run_title_screen() -> void:
	timer = get_tree().create_timer(0.3)
	await timer.timeout
	
	for slide in slides:
		currentSlide = slide
		slide.run_sequence()
		await slide.s_Finished
	
	timer = get_tree().create_timer(0.05)
	await timer.timeout
	GameController.change_scene("main_menu")
