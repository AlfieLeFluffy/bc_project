extends CanvasLayer

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

@onready var menuLabel = $PersistenceMenu/MenuLabel
@onready var grid = $PersistenceMenu/Grid

"""
--- Setup Methods
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_ui()
	setup_base_items()
	setup_savefiles()
	
	connect("closeMenu",close_menu)

"""
--- Runtime Methods
"""
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

"""
--- Persistence Methods
"""
func setup_ui() -> void:
	match mode:
		modeEnum.SAVE:
			menuLabel.text = "SAVE GAME"
		modeEnum.LOAD:
			menuLabel.text = "LOAD GAME"

func setup_base_items() -> void:
	if mode == modeEnum.SAVE:
		var newSaveItem = newSaveItemPreload.instantiate()
		newSaveItem.menuNode = self
		grid.add_child(newSaveItem)

func setup_savefiles() -> void:
	var dir = DirAccess.open(Global.savesDirectoryPath)
	if dir:
		var files = dir.get_files()
		for file in files:
			if file.ends_with(".sf"):
				var item
				if mode == modeEnum.SAVE:
					item = saveItemPreload.instantiate()
				elif mode == modeEnum.LOAD:
					item = loadItemPreload.instantiate()
				item.filename = file
				item.menuNode = self
				item.date = Time.get_datetime_string_from_unix_time(FileAccess.get_modified_time(Global.savesDirectoryPath+"/"+file))
				grid.add_child(item)
	else:
		printerr("Could not load saves directory.")

func close_menu() -> void:
	queue_free()

"""
--- Node Signal Methods
"""
func _on_cancel_button_pressed() -> void:
	queue_free()

func _on_active_button_pressed() -> void:
	pass # Replace with function body.
