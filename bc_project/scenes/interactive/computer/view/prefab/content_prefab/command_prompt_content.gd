class_name CommandPromptContent extends ApplicationContent

#region Command Setup Variables
"""
--- Command Setup
"""
enum commandTypes {LS,CD,CAT,HELP}

@export var commandReverse: Dictionary ={
	"ls" : commandTypes.LS,
	"cd" : commandTypes.CD,
	"cat" : commandTypes.CAT,
	"help" : commandTypes.HELP,
}

@export var commandMaxArguments: Dictionary ={
	commandTypes.LS : 1,
	commandTypes.CD : 1,
	commandTypes.CAT : 99,
	commandTypes.HELP : 1,
}

@export var commandMethods: Dictionary ={
	commandTypes.LS : command_ls,
	commandTypes.CD : command_cd,
	commandTypes.CAT : command_cat,
	commandTypes.HELP : command_help,
}


@export var errorMessages: Dictionary ={
	-1 : "APPLICATION_COMMAND_ERROR_1",
	-2 : "APPLICATION_COMMAND_ERROR_2",
	-3 : "APPLICATION_COMMAND_ERROR_3",
	-10 : "APPLICATION_COMMAND_ERROR_10",
	-11 : "APPLICATION_COMMAND_ERROR_11",
	-12 : "APPLICATION_COMMAND_ERROR_12",
	-99 : "APPLICATION_COMMAND_ERROR_99",
}

@export var helpMessages: PackedStringArray =[
	"APPLICATION_COMMAND_PROMPT_HELP_HELP",
	"APPLICATION_COMMAND_PROMPT_HELP_LS",
	"APPLICATION_COMMAND_PROMPT_HELP_CD",
	"APPLICATION_COMMAND_PROMPT_HELP_CAT",
]


@export var commandSymbols: PackedStringArray = ["/"]
#endregion

#region Variables
"""
--- Runtime Variables
"""
var defaultFilepath: Array
var currentFilepath: Array
var currentDirectoryName: String
var currentDirectory: Dictionary

var savedCommands: Array
var savedCommandsIndex: int = 0
#endregion

#region Setup Methods
"""
--- Setup Methods
"""
func _setup_content() -> void:
	defaultFilepath.append(["root",computer.dirFileRes.root])
	currentFilepath.append(["root",computer.dirFileRes.root])
	currentDirectoryName = "root"
	currentDirectory = computer.dirFileRes.root
	%CommandOutput.append_text("[color=web_gray]\t%s[/color][color=green]/help[/color]\n" % tr("APPLICATION_COMMAND_PROMPT_TOAST_OS_GREET"))
	%CommandInput.grab_focus()
	%CommandOutput.append_text("[color=dim_gray][font top=15]%s: " % computer.dirFileRes.create_filepath_string(currentFilepath))
#endregion

#region Runtime Methos
"""
--- Runtime Methods
"""
func _unhandled_input(event: InputEvent) -> void:
	if not "keycode" in event:
		return
	if event.keycode == KEY_UP:
		if savedCommandsIndex > 0:
			%CommandInput.text = savedCommands[savedCommandsIndex]
			savedCommandsIndex = savedCommandsIndex - 1
		elif savedCommandsIndex == 0:
			%CommandInput.text = savedCommands[savedCommandsIndex]
		%CommandInput.caret_column = len(%CommandInput.text)
	elif event.keycode == KEY_DOWN:
		if savedCommandsIndex < savedCommands.size()-1:
			savedCommandsIndex = savedCommandsIndex + 1
			%CommandInput.text = savedCommands[savedCommandsIndex]
		if savedCommandsIndex == savedCommands.size()-1:
			%CommandInput.text = savedCommands[savedCommandsIndex]
		%CommandInput.caret_column = len(%CommandInput.text)

func save_command(input: String) -> void:
	savedCommands.append(input)

func run_command(input: String) -> void:
	var parsedInput: Array = parse_command(input)
	
	if parsedInput[0] < 0:
		output_error(input, parsedInput.get(0))
		return
	
	if parsedInput.get(1).size() > commandMaxArguments[parsedInput.get(0)]:
		output_error(input, -10)
		return
	
	%CommandOutput.append_text("%s[/font]\n" % tr(input))
	var error: int = commandMethods[parsedInput.get(0)].call(parsedInput.get(1))
	if error < 0:
		output_error(input, error)
		return
	
	%CommandOutput.append_text("[color=dim_gray][font top=15]%s: " % computer.dirFileRes.create_filepath_string(currentFilepath))

func parse_command(input: String) -> Array:
	if not input.begins_with(commandSymbols.get(0)):
		return [-1]
	var strippedInput: String = input.strip_edges().lstrip(commandSymbols.get(0))
	var splitInput: PackedStringArray = strippedInput.split(" ")
	
	if splitInput[0] == "":
		return [-2]
	
	if not commandReverse.has(splitInput[0].to_lower()):
		return [-3]
		
	var command: commandTypes = commandReverse[splitInput[0].to_lower()]
	splitInput.remove_at(0)
	return [command,splitInput]

func output_error(input: String, error: int) -> void:
	%CommandOutput.append_text("[color=red]\n%s" % tr("APPLICATION_COMMAND_ERROR_BEGINNING"))
	if errorMessages.has(error):
			%CommandOutput.append_text(tr(errorMessages[error]))
	else:
			%CommandOutput.append_text(tr(errorMessages[-99]))
	%CommandOutput.append_text("%s'%s'[/color]\n" % [tr("APPLICATION_COMMAND_ERROR_ENDING"),input])
#endregion

#region Command Methods
"""
--- Command Methods
"""
func command_base(args: Array) -> int:
	return 0

func command_ls(args: Array) -> int:
	if args.size() > 0 and not args.has("-r"):
		return -11
	
	%CommandOutput.append_text("[color=silver]%s:[/color]\n" % tr(currentDirectoryName))
	if args.has("-r"):
		print_directory(currentDirectory,1,true)
		return 0
	print_directory(currentDirectory,1)
	return 0

func print_directory(directory: Dictionary, indent: int, recur:bool = false) -> void:
	var indentation: String = GameController.multiply_string("\t",indent)
	for key in directory.keys():
		if directory[key] is Dictionary:
			%CommandOutput.append_text("[color=green_yellow]%s-%s/\n" % [indentation,tr(key)])
			if recur:
				print_directory(directory[key],indent+1,true)
	for key in directory.keys():
		if directory[key] is String:
			%CommandOutput.append_text("[color=silver]%s-%s\n" % [indentation,tr(key)])
	%CommandOutput.append_text("[/color]")

func command_cd(args: Array) -> int:
	if args.size() == 0:
		return move_filepath_default()
	if args.get(0) == "..":
		return move_filepath_up()
	return move_filepath(args.get(0))

func move_filepath_default() -> int:
	currentFilepath = defaultFilepath.duplicate()
	currentDirectoryName = currentFilepath[0][0]
	currentDirectory = currentFilepath[0][1]
	return 0

func move_filepath_up() -> int:
	if currentFilepath.size()>1:
		currentFilepath.pop_back()
	currentDirectoryName = currentFilepath.back()[0]
	currentDirectory = currentFilepath.back()[1]
	return 0

func move_filepath(_filepath: String) -> int:
	var destination: Array = computer.dirFileRes.get_filepath_destination(_filepath,currentDirectory)
	if destination.get(0) < 0:
		return destination.get(0)
	match destination.get(0):
		0:
			move_filepath_recur(computer.dirFileRes.split_filepath(_filepath))
		1:
			return -12
	return 0

func move_filepath_recur(_filepath: Array):
	var key: String = computer.dirFileRes.find_destination_in_directory(_filepath.get(0),currentDirectory)
	currentFilepath.append([key,currentDirectory[key]])
	currentDirectoryName = key
	currentDirectory = currentDirectory[key]
	if _filepath.size() > 1:
		_filepath.pop_front()
		move_filepath_recur(_filepath)

func command_cat(args: Array) -> int:
	var destination: Array = computer.dirFileRes.get_filepath_destination(args.get(0),currentDirectory)
	if destination.get(0) < 0:
		return destination.get(0)
	match destination.get(0):
		0:
			return -13
		1:
			%CommandOutput.append_text("[color=silver]%s[/color]\n" % tr(destination[2]))
	return 0

func command_help(args: Array) -> int:
	%CommandOutput.append_text("[color=silver]%s[/color]\n" % tr("APPLICATION_COMMAND_PROMPT_HELP_SETUP"))
	for message in helpMessages:
		%CommandOutput.append_text("[color=silver]\t%s[/color]\n" % tr(message))
	return 0
#endregion

#region Signal Methods
"""
--- Signal Methods
"""
func _on_command_input_text_submitted(new_text: String) -> void:
	run_command(new_text)
	save_command(new_text)
	%CommandInput.clear()
	savedCommandsIndex = savedCommands.size()-1
#endregion
