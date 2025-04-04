class_name PersistenceMenu extends Control



"""
--- Preload Prefabs
"""
#region Preloaded Prefab Constants
## Preloaded list item for a new save
const newSaveItemPreload = preload("res://scripts/persistence/prefabs/new_save_item.tscn")
## Preloaded list item for an existing save override
const saveItemPreload = preload("res://scripts/persistence/prefabs/save_item.tscn")
## Preloaded list item for a loading a save
const loadItemPreload = preload("res://scripts/persistence/prefabs/load_item.tscn")

## A string for date time formating
const TIME_STRING_FORMAT:String = "%d:%d:%d - %d.%d.%d"
#endregion

"""
--- Signals
"""

## Signal for closing the menu
signal closeMenu

"""
--- Runtime Variables
"""
## For setting up which version of the persistence menu should open.
enum modeEnum {SAVE,LOAD}

## Variable keeping track of which type of persistence menu is open
var mode: modeEnum = modeEnum.SAVE
## Variable keeping the parent [PopupMenuController] for menu manipulation
var popupMenu: PopupMenuController

"""
--- Setup Methods
"""
#region Setup Methods
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## Checks for existence of a [PopupMenuController] parent
	popupMenu = PopupMenuController.get_popup_menu(self)
	
	$CancelButton.grab_focus()
	
	## Setup of the menu broken down into individual steps
	setup_ui()
	setup_base_items()
	setup_savefiles()
	
	## Setup of signal methods
	connect("closeMenu",close_menu)
#endregion

"""
--- Runtime Methods
"""
#region Input Methods
func _unhandled_input(event: InputEvent) -> void:
	## If prompted the menu closes otherwise it captures any input from progressing deeper
	if event.is_action_pressed("ui_menu") or event.is_action_pressed("detective_board_toggle"):
		close_menu()
	if visible:
		get_viewport().set_input_as_handled()
#endregion



#region Menu Methods
## Method for closing the menu. Release any existing focus, checks for existing [PopupMenuController] parent, otherwise queues free.
func close_menu() -> void:
	if popupMenu:
		popupMenu.popdownKill.emit()
	else:
		queue_free()
#endregion



#region Persistence Methods
## Sets up UI labels.
func setup_ui() -> void:
	match mode:
		modeEnum.SAVE:
			%TabContainer.get_child(0).name = tr("SAVE_MENU_LABEL")
		modeEnum.LOAD:
			%TabContainer.get_child(0).name = tr("LOAD_MENU_LABEL")

## Sets up basic list items present in a specific persistence menu type. [br]
## For example for a save persistence type sets up new save list item.
func setup_base_items() -> void:
	if mode == modeEnum.SAVE:
		var newSaveItem = newSaveItemPreload.instantiate()
		newSaveItem.menuNode = self
		%Grid.add_child(newSaveItem)
		var separator: HSeparator = HSeparator.new()
		separator.theme = load("res://settings/hseparator_theme.tres")
		%Grid.add_child(separator)

## Sets up list items from the savefile folder.
func setup_savefiles() -> void:
	var folderpath: String = PersistenceController.create_profile_savefile_folderpath(GameController.profile.id)
	var directory = DirAccess.open(folderpath)
	if directory:
		var dirs = directory.get_directories()
		for dir in dirs:
			setup_savefile_directory(dir)
	else:
		printerr("Could not load saves directory.")

## Sets up a single savefile directory.
func setup_savefile_directory(directory: String) -> void:
	var folderpath: String = PersistenceController.create_profile_savefile_folderpath(GameController.profile.id)
	var files = DirAccess.open(folderpath.path_join(directory)).get_files()
	for file in files:
		if file.ends_with(".sf"):
			setup_savefile_entry(file)

## Sets up a single list item entry depending on the persistence menu type.
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

## Adds a list item into the Grid based on its datetime.
func add_item_sorted(item: Control) -> void:
	var children = %Grid.get_children()
	if children.size() == 0:
		%Grid.add_child(item)
		return
		
	var amount: Array
	if mode == modeEnum.SAVE:
		amount = range(children.size())
		amount.pop_front()
		amount.pop_front()
	else:
		amount = range(children.size())
		
	for idx in amount:
		if children[idx].dateString <= item.dateString:
			%Grid.add_child(item)
			%Grid.move_child(item, idx)
			return
	%Grid.add_child(item)
	%Grid.move_child(item, children.size())
	return
#endregion



"""
--- Node Signal Methods
"""
#region Node Singnal Methods
func _on_cancel_button_pressed() -> void:
	close_menu()

func _on_active_button_pressed() -> void:
	pass # Replace with function body.
#endregion
