class_name SettingsConstants extends Node

#region Language Constants
## A constant dictionary for creating the language option buttons.
const LANGUAGE_DICTIONARY_NAME: Dictionary ={
	0: "ENGLISH_LANGUAGE",
	1: "CZECH_LANGUAGE",
}

## A constant dictionary for converting language option button index into language keys.
const LANGUAGE_DICTIONARY_KEY: Dictionary ={
	0: "en",
	1: "cz",
}
#endregion

#region Resolution Constants
## A constant holding possible resolutions
const RESOLUTION_DICTIONARY: Dictionary = {
	0: Vector2(640,360),
	1: Vector2(1280,720),
	2: Vector2(1920,1080),
	3: Vector2(2560,1440),
}
#endregion

#region Window Mode Constants
## A constant holding enable/disabled variants
const WINDOW_MODE_DICTIONARY: Dictionary = {
	0: "WINDOWED_OPTION",
	2: "MAXIMIZED_OPTION",
	3: "FULLSCREEN_OPTION",
}
#endregion

#region Resolution Constants
## A constant holding enable/disabled variants
const TOGGLE_DICTIONARY: Dictionary = {
	0: "DISABLED_OPTION",
	1: "ENABLED_OPTION",
}
#endregion

#region Audio Constants
## A constant holding the min/max range of the audio sliders
const AUDIO_SLIDER_RANGE: Vector2 = Vector2(0.0,1.0)

## A constant holding the slider step value
const AUDIO_SLIDER_STEP: float = 0.1
#endregion
