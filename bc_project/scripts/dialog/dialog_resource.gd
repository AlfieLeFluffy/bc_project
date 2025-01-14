class_name DialogResource extends Resource

@export_group("Dialog Resources")
@export var dialog: DialogueResource
@export var titleName: String

func increment_title_name() -> void:
	var titles = dialog.get_titles()
	if titles.size() > titles.find(titleName)+1:
		titleName = titles[titles.find(titleName)+1]

func set_title_name(newTitleName) -> void:
	titleName = newTitleName
