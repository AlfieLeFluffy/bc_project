extends Node2D

var Timelines

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Timelines = $Timelines.get_children()
	for timeline in Timelines:
		timeline.visible = false
	Global.TimelineIndex = 0
	UpdateTimeline()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("timeline_shift") and Global.TimelineShiftReady:
		TimelineTimeout()
		CycleTimeline()

func CycleTimeline() -> void:
	Timelines[Global.TimelineIndex].visible = false
	Global.TimelineIndex += 1
	if Global.TimelineIndex >= Timelines.size():
		Global.TimelineIndex = 0
	UpdateTimeline()

func UpdateTimeline() -> void:
	Timelines[Global.TimelineIndex].visible = true
	Global.Timeline = Timelines[Global.TimelineIndex].name
	$player.Update()
	
func TimelineTimeout() -> void:
	Global.TimelineShiftReady = false
	await get_tree().create_timer(Global.TIMELINE_TIMEOUT).timeout
	Global.TimelineShiftReady = true
