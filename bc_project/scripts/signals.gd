extends Node

# Signals for updating player overlay
signal update_overlay()

# Signals for deleting board elements
signal delete_line(line)
signal delete_element(element)

# Signals for creating board elements
signal create_item_element(texture,lable,text)

# Signals for help tips
signal help_text_toggle(type,direction)
