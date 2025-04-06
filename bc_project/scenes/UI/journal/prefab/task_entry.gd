class_name TaskEntry extends MarginContainer

@export var task: TaskResource

@export var isExpanded: bool = false
@export var lastSize: Vector2 = Vector2.ZERO

func _ready() -> void:
	if not task:
		queue_free()
	
	setup_entry.call_deferred()
	setup_collapse_button.call_deferred()
	
	task.changed.connect(setup_entry)


func setup_entry() -> void:
	%TaskNameLabel.parse_bbcode("[color=#%s]%s[/color]\n" % [task.get_color().to_html(),task.name])
	setup_steps.call_deferred()

func setup_steps() -> void:
	%StepList.clear()
	for step: TaskStepResource in task.history:
		%StepList.append_text("[color=#%s] - %s[/color]\n" % [step.get_color().to_html(),step.name])
	
	if task.finished:
		var color: Color = Color.WHITE
		color = color.lerp(Color.TRANSPARENT,0.5)
		if task.failed:
			color = color.lerp(Color.RED,0.5)
		%Content.modulate = color

func setup_collapse_button() -> void:
	if %Content.visible:
		%CollapseButton.text = "CLOSE_BUTTON"
	else:
		%CollapseButton.text = "OPEN_BUTTON"


func _on_collapse_button_pressed() -> void:
	%Content.visible = not %Content.visible
	setup_collapse_button()
