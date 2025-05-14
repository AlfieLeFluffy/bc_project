class_name CombinationLockResource extends Resource

#region Exported Variables
@export_category("Combination Informations")
@export var combination: String
@export var locked: bool = true
@export var override: bool = false

@export_category("Character Lock Informations")
@export var size: int = 5

@export_category("Callable Resources Override")
@export var callables: Array[CallableResource]
#endregion

func check_combination(input: String) -> bool:
	if combination.strip_edges() == input.strip_edges():
		return true
	return false
