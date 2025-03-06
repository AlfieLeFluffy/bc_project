class_name FileExplorerContent extends ApplicationContent

#region Variables, Constants and such
"""
--- Directory File Type
"""
enum dirFileType {FOLDER_EMPTY,FOLDER_FULL,FILE}

"""
--- Runtime Variables
"""
var currentFilepath: Array
var currentDirectory: Dictionary
var historyFilepath: Array 

@export var dirFileIcons: Dictionary= {
	dirFileType.FOLDER_EMPTY : "res://textures/computer/file_explorer_icons/folder_empty.png",
	dirFileType.FOLDER_FULL : "res://textures/computer/file_explorer_icons/folder_full.png",
	dirFileType.FILE : "res://textures/computer/file_explorer_icons/file.png",
}
#endregion

#region Setup Methods
"""
--- Setup Methods
"""
func _setup_content() -> void:
	currentFilepath.append(["root",computer.dirFileRes.root])
	currentDirectory = computer.dirFileRes.root
	setup_current_state()

func setup_current_state() -> void:
	%FilepathEdit.text = computer.dirFileRes.create_filepath_string(currentFilepath)
	setup_directory_list(currentDirectory)

func setup_directory_list(directory: Dictionary) -> void:
	%FileDirectoryList.clear()
	# Adding directorires
	for key in directory:
		if directory[key] is Dictionary and key != computer.dirFileRes.bakctrackName:
			create_directory_item(key,directory[key])
	%FileDirectoryList.sort_items_by_text()
	# Adding files
	for key in directory:
		if directory[key] is Dictionary:
			continue
		if directory[key] is String:
			create_file_item(key,directory[key])
		else:
			printerr("Unknown file/directory type during file explorer directory list setup of key: " + key)

func create_directory_item(dirname:String, directory: Dictionary) -> void:
	if directory.is_empty():
		%FileDirectoryList.add_item(dirname,load_dir_file_icon(dirFileType.FOLDER_EMPTY))
		return
	%FileDirectoryList.add_item(dirname,load_dir_file_icon(dirFileType.FOLDER_FULL))

func create_file_item(filename: String, contents:String) -> void:
	%FileDirectoryList.add_item(filename,load_dir_file_icon(dirFileType.FILE))

func load_dir_file_icon(key: dirFileType) -> CompressedTexture2D:
	var compTexture: CompressedTexture2D
	if dirFileIcons.has(key):
		compTexture = load(dirFileIcons[key])
	return compTexture
#endregion

#region Runtime Methods
"""
--- Runtime Methods
"""
func find_filepath(filepath: String) -> void:
	pass

func open_filepath(item: String) -> void:
	if not currentDirectory.has(item):
		printerr("Error: Current directory doesn't contain file or directory of name:" + item)
		return
	
	if currentDirectory[item] is Dictionary:
		historyFilepath.append(currentFilepath.duplicate())
		currentFilepath.append([item,currentDirectory[item]])
		currentDirectory = currentDirectory[item]
		setup_current_state()
	elif currentDirectory[item] is String:
		computer.view.application_open.emit(computer.appRes.applicationTypes.TEXT_VIEW,{"text":currentDirectory[item]})

func up_directory() -> void:
	var upDirectory: Array
	historyFilepath.append(currentFilepath.duplicate())
	if currentFilepath.size() > 1:
		currentFilepath.pop_back()
	upDirectory = currentFilepath.get(currentFilepath.size()-1)
	currentDirectory = upDirectory.get(1)
	setup_current_state()

func back_directory() -> void:
	var backtrackFilepath: Array
	if historyFilepath.size() == 0:
		return
	backtrackFilepath = historyFilepath.get(historyFilepath.size()-1)
	if historyFilepath.size() > 1:
		historyFilepath.pop_back()
	currentFilepath = backtrackFilepath
	currentDirectory = currentFilepath.get(currentFilepath.size()-1).get(1)
	setup_current_state()
#endregion

#region Signal Methods
"""
--- Signal Methods
"""
""" Selected directory file item """
func _on_file_directory_list_item_selected(index: int) -> void:
	var selectedItemText: String = %FileDirectoryList.get_item_text(index)
	open_filepath(selectedItemText)

""" Finding filepath """
func _on_filepath_edit_text_submitted(new_text: String) -> void:
	print("Need to finish up translation issue")
	#find_filepath(new_text)

func _on_find_button_pressed() -> void:
	print("Need to finish up translation issue")
	#find_filepath(%FilepathEdit.text)

""" Backtrack and Up Dictionary """
func _on_back_button_pressed() -> void:
	back_directory()

func _on_up_button_pressed() -> void:
	up_directory()
#endregion
