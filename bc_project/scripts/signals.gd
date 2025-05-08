extends Node
## An autoload script that hold all globally accesable signals that are not tied to another autoload script.

#region Timeline Shift Signals
## A signal that triggers the timeline shift screen effect.
signal s_TimelineShift()
#endregion

#region Camera Controls Signals
## Signal for setting the tracked property of the [CameraControls] to a spefic node.[br]
##
## - [param node] hold the Node2D class which the camera should start tracking.
signal s_CameraTrackedNodeSet(node: Node2D)
## Signal for setting the tracked property of the [CameraControls] to a spefic node by its name.[br]
##
## - [param nodeName] hold name of the Node2D the camera should start tracking. The cemara controls methods attempts to find the node.
signal s_CameraTrackedNodeSetByName(nodeName: String)
## Signal for setting the tracked property of the [CameraControls] to the player character.[br]
signal s_CameraTrackedNodeSetPlayer()
## Signal for setting the tracked property of the [CameraControls] to the last known position of the previous tracked node.[br]
signal s_CameraTrackedNodeSetEmpty()
#endregion

#region Overlay Signals
## Signal for forcing a Main Overlay update
signal s_UpdateMainOverlay()
#endregion

#region Menu Signals
## Signal for clearing a active state when a menu is opened.
signal s_MenuClear()
## Signal for notifying that the menu animation has finished.
signal s_MenuAnimationFinished()
#endregion

#region Lights Signals
## Signal used to set a [Light] state.[br]
##
## - [param circuit] is used to identify which lights are to be set.[br]
## - [param state] is the state to which they will be set.[br]
signal s_SetLight(circuit: String, state: bool)
## Signal used to toggling a [Light] state.[br]
##
## - [param circuit] is used to identify which lights are to be toggled.[br]
signal s_ToggleLight(circuit: String)
#endregion

#region Board Signals
## Signals used to set the current active element for further use.[br]
##
## - [param element] is the current active element.[br]
signal s_SetActiveBoardElement(element: ElementBase)

## Signals used to create a new board element.[br]
##
## - [param elementResource] is a resource of the new element.[br]
signal s_CreateBoardElement(elementResource: ElementResource)

## Signals used to delete a board element.[br]
##
## - [param elementName] is the name of the element to be deleted.[br]
signal s_DeleteBoardElement(elementName: String)
## Signals used to delete a board connection.[br]
##
## - [param connection] is connection instance to be deleted.[br]
signal s_DeleteBoardConnection(connection: ConnectionBase)
#endregion

#region Input Help Signals
## Signal for setting an input help into the overlay.[br]
##
## - [param input] is an array of strings holding all input keys related to the action in.[br]
## - [param description] holds the translation key for the input help label.
## This keys is also used for keeping track of the label.[br]
signal s_InputHelpSet(input: Array, description: String)

## Signal for free an input help label, if there is one of said description.[br]
##
## - [param description] holds the translation key for the input help label. 
## This keys is also used for keeping track of the label.[br]
signal s_InputHelpFree(description: String)
#endregion

# Singnal for notifying npc state machine about conversation starting/ending
signal setup_level_dialogue_variables(variables)
signal start_npc_conversation_state(npc)
signal setup_conversation_profile(side,character_name,picture)
signal end_npc_conversation_state()

#region Computer Signals
## Signal for shutting down a computer.
##
## - [param computerName] is used to idenetify which computer is supposed to shutdown.
## It is the parameter [param name] held in [ComputerObjectResource].
signal s_ShutdownComputer(computerName: String)
## Signal for hiding a computer view menu.
##
## - [param computerName] is used to idenetify which computer is supposed to shutdown.
## It is the parameter [param name] held in [ComputerObjectResource].
signal s_HideComputerView(computerName: String)
#endregion

#region Elevator Signals
## Signal for sending an elevator to a specific stop.[br]
###
## - [param id] is used to identify the elevator. This is kept in the [ElevatorResource].[br]
## - [param stop] is used to identify the stop to which the elevator should move to. Stops are kept in the [ElevatorResource].[br]
## There are safety protections on both inputs.
signal s_ElevatorMoveToKey(id: String, key: String)
## Signal for sending an elevator to a specific vector.[br]
##
## - [param id] is used to identify the elevator. This is kept in the [ElevatorResource].[br]
## - [param vector] is used to set a specific position to whic the elevator should move.[br]
## There are safety protections on both inputs.
signal s_ElevatorMoveToVector(id: String, vector: Vector2)
#endregion

#region Door Signals
## Signal for openning a door. This does not ignore the [param locked] property.[br]
##
## - [param id] is used for identifing a specific door. This information is held in [InteractableResource].[br]
signal s_OpenDoor(id: String)
## Signal for clsoing a door. This does not ignore the [param locked] property.[br]
##
## - [param id] is used for identifing a specific door. This information is held in [InteractableResource].[br]
signal s_CloseDoor(id: String)

## Signal for toggling the locked property of a door.[br]
##
## - [param id] is used for identifing a specific door. This information is held in [InteractableResource].[br]
signal s_ToggleDoorLock(id: String)
## Signal for setting the locked property of a door.[br]
##
## - [param id] is used for identifing a specific door. This information is held in [InteractableResource].[br]
## - [param state] is the state to which the locked property will be set.
signal s_SetDoorLock(id: String, state: bool)
#endregion
