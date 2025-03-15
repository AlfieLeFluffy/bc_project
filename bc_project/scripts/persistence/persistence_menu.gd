class_name PersistenceMenu extends CanvasLayer

enum modeEnum {SAVE,LOAD}

"""
--- Preload Prefabs
"""
const newSaveItemPreload = preload("res://scripts/persistence/prefabs/new_save_item.tscn")
const saveItemPreload = preload("res://scripts/persistence/prefabs/save_item.tscn")
const loadItemPreload = preload("res://scripts/persistence/prefabs/load_item.tscn")

"""
--- Signals
"""

signal closeMenu

"""
--- Runtime Variables
"""
var mode: modeEnum = modeEnum.SAVE
var popupMenu: PopupMenuController

@onready var menuLabel = $PersistenceMenu/MenuLabel
@onready var grid = $PersistenceMenu/Grid

const TIME_STRING_FORMAT:String = "%d:%d:%d - %d.%d.%d"

"""
--- Setup Methods
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	popupMenu = PopupMenuController.get_popup_menu(self)
	
	setup_ui()
	setup_base_items()
	setup_savefiles()
	
	connect("closeMenu",close_menu)

"""
--- Runtime Methods
"""
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_menu") or event.is_action_pressed("detective_board_toggle"):
		close_menu()
	if visible:
		get_viewport().set_input_as_handled()

func close_menu() -> void:
	GameController.release_focus()
	if popupMenu:
		popupMenu.popdownKill.emit()
	else:
		queue_free()

"""
--- Persistence Methods
"""
func setup_ui() -> void:
	match mode:
		modeEnum.SAVE:
			menuLabel.text = tr("SAVE_GAME_LABEL")
		modeEnum.LOAD:
			menuLabel.text = tr("LOAD_GAME_LABEL")

func setup_base_items() -> void:
	if mode == modeEnum.SAVE:
		var newSaveItem = newSaveItemPreload.instantiate()
		newSaveItem.menuNode = self
		grid.add_child(newSaveItem)

func setup_savefiles() -> void:
	var folderpath: String = PersistenceController.create_profile_savefile_folderpath(GameController.profile.id)
	var directory = DirAccess.open(folderpath)
	if directory:
		var dirs = directory.get_directories()
		for dir in dirs:
			setup_savefile_directory(dir)
	else:
		printerr("Could not load saves directory.")

func setup_savefile_directory(directory: String) -> void:
	var folderpath: String = PersistenceController.create_profile_savefile_folderpath(GameController.profile.id)
	var files = DirAccess.open(folderpath.path_join(directory)).get_files()
	for file in files:
		if file.ends_with(".sf"):
			setup_savefile_entry(file)

func setup_savefile_entry(file: String) -> void:#
	var item
	if mode == modeEnum.SAVE:
		item = saveItemPreload.instantiate()
	elif mode == modeEnum.LOAD:
		item = loadItemPreload.instantiate()
	item.filename = file
	item.menuNode = self
	var folderpath: String = PersistenceController.create_profile_savefile_folderpath(GameController.profile.id)
	var filepath: String = folderpath.path_join(file.rstrip(".sf"))
	var time: Dictionary = Time.get_datetime_dict_from_unix_time(FileAccess.get_modified_time(filepath))
	item.date = TIME_STRING_FORMAT % [int(time["hour"]),int(time["minute"]),int(time["second"]),int(time["day"]),int(time["month"]),int(time["year"])] 
	item.dateString = Time.get_datetime_string_from_unix_time(FileAccess.get_modified_time(filepath))
	add_item_sorted(item)

func add_item_sorted(item: Control) -> void:
	var children = grid.get_children()
	if children.size() == 0:
		grid.add_child(item)
		return
	else:
		for idx in range(children.size()):
			if children[idx].dateString <= item.dateString:
				grid.add_child(item)
				grid.move_child(item, idx)
				return
	grid.add_child(item)
	grid.move_child(item, children.size())
	return

"""
--- Node Signal Methods
"""
func _on_cancel_button_pressed() -> void:
	close_menu()

func _on_active_button_pressed() -> void:
	pass # Replace with function body.
