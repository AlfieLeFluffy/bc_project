class_name LoadingScreen extends CanvasLayer

#region Runtime Variables
var sceneToLoad: String
var progressArray: Array = []
var packedScene: Resource
var lastUpdate: float = 0.0

var tween: Tween
#endregion

#region Setup Methods
func _ready() -> void:
	sceneToLoad = GameController.sceneToLoad
	ResourceLoader.load_threaded_request(sceneToLoad)
#endregion



#region Runtime Methods
func _process(delta: float) -> void:
	ResourceLoader.load_threaded_get_status(sceneToLoad,progressArray)
	if lastUpdate < progressArray[0]:
		lastUpdate = progressArray[0]
		update_progress()

func update_progress() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(%ProgressBar,"value",lastUpdate,0.1).set_ease(Tween.EASE_IN_OUT)
	if progressArray[0] >= 1.0:
		packedScene = ResourceLoader.load_threaded_get(sceneToLoad)
		await tween.finished
		get_tree().change_scene_to_packed(packedScene)
#endregion
