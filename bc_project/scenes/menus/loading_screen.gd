extends MarginContainer

var Scene
var progress
var packedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Scene = Global.NextScene
	ResourceLoader.load_threaded_request(Scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress = []
	ResourceLoader.load_threaded_get_status(Scene,progress)
	$TextureProgressBar.value = progress[0]*100
	if progress[0] == 1:
		packedScene = ResourceLoader.load_threaded_get(Scene)
		get_tree().change_scene_to_packed(packedScene)
