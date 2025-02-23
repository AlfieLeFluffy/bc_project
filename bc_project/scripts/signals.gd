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

# Signals for deleting board elements
signal delete_line(line)
signal delete_element(element)

# Signals for creating board elements
signal create_item_element(texture,lable,text)

# Signals for input help setting
signal input_help_set(input,description)
signal input_help_delete(description)

# Singnal for notifying npc state machine about conversation starting/ending
signal start_npc_conversation_state(npc)
signal setup_conversation_profile(side,character_name,picture)
signal end_npc_conversation_state()
