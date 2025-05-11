class_name DirectoryFileResource extends Resource

@export var root: Dictionary

#region Directory File Methods
"""
--- DirFile Methods
"""

func split_filepath(filepath:String) -> PackedStringArray:
	var output: PackedStringArray = filepath.strip_edges().split("/")
	return output

func create_filepath_string(_filepath: Array) -> String:
	var output: String = ""
	for directory in _filepath:
		output = output + tr(directory[0]) + "/"
	return output

func get_filepath_destination(_filepath:String, _directory: Dictionary) -> Array:
	var key: String = ""
	var directory: Dictionary = _directory
	var splitFilepath: PackedStringArray = split_filepath(_filepath)
	while splitFilepath.size() > 1:
		key = find_destination_in_directory(splitFilepath.get(0),directory)
		if key == "":
			return [-12]
		if not directory[key] is Dictionary:
			return [-12]
		directory = directory[key]
		splitFilepath.remove_at(0)
	
	key = find_destination_in_directory(splitFilepath.get(0),directory)
	if key == "":
		return [-12]
	if directory[key] is Dictionary:
		return [0, key, directory[key]]
	if directory[key] is String:
		return [1, key, directory[key]]
	
	return [-99]

func find_destination_in_directory(_destination:String, _directory: Dictionary) -> String:
	var found: String = ""
	for key in _directory.keys():
		if tr(key) == _destination:
			found = key
	return found
#endregion
