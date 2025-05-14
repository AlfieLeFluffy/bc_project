class_name GameOverResource extends Resource

enum e_GameOverType {CLIPPED, RETIRED, MISSING}

const info: Dictionary = {
	e_GameOverType.CLIPPED : {"name":"CLIPPED_GAME_OVER_NAME", "description": "CLIPPED_GAME_OVER_DESCRIPTION", "color":Color.DARK_RED, "icon" : null, "achievement": AchievementsResource.e_AchievementType.HOW_DID_WE_GET_HERE},
	e_GameOverType.RETIRED : {"name":"RETIREMENT_GAME_OVER_NAME", "description": "RETIREMENT_GAME_OVER_DESCRIPTION", "color":Color.KHAKI, "icon" : null, "achievement": AchievementsResource.e_AchievementType.RETIREMENT},
	e_GameOverType.MISSING : {"name":"MISSING_GAME_OVER_NAME", "description": "MISSING_GAME_OVER_DESCRIPTION", "color":Color.DIM_GRAY, "icon" : null, "achievement": AchievementsResource.e_AchievementType.MISSING},
}
