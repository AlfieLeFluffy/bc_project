class_name CombinationLockView extends CanvasLayer

const preloadCombinationInput = preload("res://scenes/interactive/combination/prefab/combination_input.tscn")
const numberArray: Array[String] = ["0","1","2","3","4","5","6","7","8","9"]
const alphabet: String = "abcdefghijklmnopqrstuvwxyz"

enum types {NUMBERS,CHARACTERS,BOTH}

var base: CombinationLockBase
var type: types

var inputs: Array[CombinationInput]

#region Setup Methods
func _ready() -> void:
	if not check_base():
		return
	
	setup_locked()
	
	type = get_combination_type(base.resource.combination)
	
	if type == types.NUMBERS:
		setup_number_lock()
	else:
		setup_character_lock()
	
func check_base() -> bool:
	if not base:
		printerr("Error: Combination lock view doesn't have base.")
		return false
	if not base.resource:
		printerr("Error: Combination lock view, base doesn't have a resource.")
		return false
	if not base.resource is CombinationLockResource:
		printerr("Error: Combination lock view, base resource is invalid.")
	if not base.resource.combination:
		printerr("Error: Combination lock view, base resource combination is empty.")
		return false
	return true

func setup_locked() -> void:
	if not base.resource.locked:
		%Lock.visible = false
	

func get_combination_type(combination: String) -> types:
	var regex = RegEx.new()
	regex.compile("(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+)$")
	if regex.search(combination):
		return types.BOTH
	regex.compile("[a-zA-Z]+")
	if regex.search(combination):
		return types.CHARACTERS
	regex.compile("[0-9]+")
	if regex.search(combination):
		return types.NUMBERS
	return types.BOTH

func setup_combination_input(array: Array) -> void:
	var input: CombinationInput = preloadCombinationInput.instantiate()
	input.view = self
	input.array = array
	inputs.append(input)
	%Inputs.add_child(input)

func setup_number_lock() -> void:
	var split: PackedStringArray = base.resource.combination.split("")
	for number in split:
		setup_number_input()
	
func setup_number_input() -> void:
	setup_combination_input(numberArray)

func setup_character_lock() -> void:
	var split: PackedStringArray = base.resource.combination.split("")
	for character in split:
		setup_character_input(character)
	
func setup_character_input(character: String) -> void:
	var localSeed = GameController.profile.seed + character.unicode_at(0)
	var split: PackedStringArray = alphabet.split("")
	var array: Array[String] = []
	array.append(character)
	for i in range(base.resource.size):
		var newCharacter: String = split[localSeed % 26]
		var repeat: int = 1
		while array.has(newCharacter):
			newCharacter = split[localSeed % 26+repeat]
			repeat += 1
		array.append(newCharacter)
		localSeed = rand_from_seed(localSeed)[0]
	array.sort()
	setup_combination_input(array)
#endregion



#region Runtime Methods
func submit_inputs() -> void:
	var value: String = get_inputs()
	if base.resource.check_combination(value):
		base.resource.locked = false
		setup_locked()

func get_inputs() -> String:
	var values: PackedStringArray
	for input in inputs:
		values.append(input.get_current_input())
	return "".join(values)
#endregion



#region Signal Methods
func _on_submit_button_pressed() -> void:
	submit_inputs()
#endregion
