class_name CameraZoom extends Camera2D


## Minimal zoom vector2 that can be set through input.
@export var minZoom: Vector2 = Vector2(2.0,2.0)
## Maximum zoom vector2 that can be set through input.
@export var maxZoom: Vector2 = Vector2(4.0,4.0)
## Vector2 for one step of the zoom process.
@export var zoomStep: Vector2 = Vector2(0.2,0.2)
## Tween reference for keeping track of zoom tween.
var tween: Tween

#region Runtime Methods
func _unhandled_input(event: InputEvent) -> void:
	## If event included zoom in our out action then it is called upon.
	if event.is_action("zoom_in"):
		change_zoom(zoom+zoomStep)
	elif event.is_action("zoom_out"):
		change_zoom(zoom-zoomStep)

## Method for handling zooming feature. [br]
## Requires an input vector2 of the desired zoom. The function restricts the input to the [param maxZoom] and [param minZoom] constrains.
func change_zoom(input: Vector2) -> void:
	## Creates a new tween.
	tween = get_tree().create_tween()
	## Restricts input by constraints.
	input = minZoom.max(input.min(maxZoom))
	## Sets tween property to the zoom property of the main camera, sets the desired endpoint, time and ease. 
	tween.tween_property(self, "zoom", input, 0.2).set_ease(Tween.EASE_IN_OUT)
#endregion
