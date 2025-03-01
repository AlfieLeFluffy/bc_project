extends Node

# Signals for updating player overlay
signal timeline_shift()

# Signals for setting what node the camera is following
signal set_tracked_node(node)

# Signals for updating player overlay
signal update_overlay()

# Signals opening of a new menu, used to clear active 
signal menu_clear()

# Signals for updating lighting scenes
signal set_light(circuitSignal,state)
signal toggle_light(circuitSignal)

# Signals for updating player overlay
signal scene_loaded()
signal game_loaded()

signal set_active_element(element)
# Signals for creating and deleting board elements
signal create_board_element(elementType,elementName,elementTexture,elementDescription)
signal delete_board_element(element)
# Signals for deleteing line elements
signal delete_board_line(line)

# Signals for input help setting
signal input_help_set(input,description)
signal input_help_delete(description)

# Singnal for notifying npc state machine about conversation starting/ending
signal start_npc_conversation_state(npc)
signal setup_conversation_profile(side,character_name,picture)
signal end_npc_conversation_state()

signal shutdown_computer(computerName)
