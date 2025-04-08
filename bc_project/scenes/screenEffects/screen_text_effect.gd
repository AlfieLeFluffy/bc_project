class_name ScreenTextEffect extends CanvasLayer

## A text input that will be displayed.
## Every line has to be separated by a ';' character.
## Any white characters around a line will be stripped.
## BBCode is enabled and can be used withint the text.
@export var input: String
## Time between each line appearing.
@export var lineTimeout: float = 0.1
## Time between each character in a line appearing.
@export var characterTimeout: float = 0.06
## Time after text finishes.
@export var finishTimeout: float = 3.0

## A list of all lines that need to be displayed.
var list: PackedStringArray
## If true the setup line will skip to the end of the line.
var skipLine: bool = false


#region Screen Effect Methods
func _ready() -> void:
	## Checks if input exists.
	if not input:
		queue_free()
	
	## Splits input by semicolon.
	list = input.split(";")
	
	## Display a line for every line in the list.
	## Await structure for sequential displaying.
	for entry in list:
		await setup_line(entry)
		await get_tree().create_timer(lineTimeout).timeout
	
	## Waits on screen for a moment.
	await get_tree().create_timer(finishTimeout).timeout
	## Fades out text.
	await fade_out()
	## Queues free
	queue_free()

## Takes a string input [param line], creates a new RichTextLabel, adds it to the [VBoxContainer] LineBox
## and then writes out each character after one another. This function is able to use BBCode.
func setup_line(line: String) -> bool:
	var bbcodeSkip: bool = false
	var text: String = ""
	var label: RichTextLabel = RichTextLabel.new()
	label.fit_content = true
	label.bbcode_enabled = true
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var characters: PackedStringArray = line.strip_edges().split("")
	%LineBox.add_child(label)
	for character in characters:
		if skipLine:
			label.clear()
			label.parse_bbcode(line.strip_edges())
			skipLine = false
			return true
		if character == "[" or character == "]":
			bbcodeSkip = not bbcodeSkip
		text += character
		label.parse_bbcode(text)
		if not bbcodeSkip:
			await get_tree().create_timer(characterTimeout).timeout
	return true

func fade_out() -> bool:
	var tween: Tween
	if not is_inside_tree():
		return true
	tween = get_tree().create_tween()
	tween.tween_property(%Control,"modulate", Color("ffffff00") , 1.0)
	await tween.finished
	tween.kill()
	return true
#endregion

#region Interruption Method
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") or event.is_action_pressed("ui_menu") or event is InputEventMouseButton:
		skipLine = true
#endregion
