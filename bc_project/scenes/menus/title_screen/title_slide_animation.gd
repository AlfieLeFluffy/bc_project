extends Slide


func _run_animation() -> bool:
	if not skip:
		AudioManager.play_sound("sfx/clock_high")
		%TitleAnimation.texture.current_frame += 1 
		timer = get_tree().create_timer(0.05)
		await timer.timeout
		%TitleAnimation.texture.current_frame += 1 
		timer = get_tree().create_timer(1.0)
		await timer.timeout
	
	if not skip:
		AudioManager.play_sound("sfx/clock_low")
		%TitleAnimation.texture.current_frame += 1 
		timer = get_tree().create_timer(0.05)
		await timer.timeout
		%TitleAnimation.texture.current_frame += 1 
		timer = get_tree().create_timer(1.0)
		await timer.timeout
	
	if not skip:
		AudioManager.play_sound("sfx/glass_break")
		for index in range(3):
			%TitleAnimation.texture.current_frame += 1 
			timer = get_tree().create_timer(0.05)
			await timer.timeout
		%TitleAnimation.texture.current_frame += 1 
		timer = get_tree().create_timer(1.0)
		await timer.timeout
	
	timer = get_tree().create_timer(0.25)
	await timer.timeout
	await local_fade_to_color(%TitleLabel, Color.WHITE,0.5)
	timer = get_tree().create_timer(0.25)
	await timer.timeout
	
	return true
