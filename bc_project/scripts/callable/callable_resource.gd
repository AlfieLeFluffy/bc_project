class_name CallableResource extends Resource

@export_category("Callable Information")
@export var parameters: Array

func run(base: Node):
	pass

func check_target_path(tagetPath) -> bool:
	if not tagetPath:
		printerr("Error: No nodepath/nodename for callable resource of name: '%s'" % [resource_name])
		return false
	return true

func run_method(node: Node, _methodName: String):
	if not node:
		return null
	
	return await node.callv(_methodName,parameters)

func run_signal(node: Node, _signalName: String):
	if not node:
		return null
		
	if not parameters:
		return node.emit_signal(_signalName)
	else:
		return node.emit_signal(_signalName,parameters)

func get_node_by_name(base: Node, nodeName: String) -> Node:
	if not nodeName:
		printerr("Error: No node name for callable resource of name: '%s'" % [resource_name])
		return null
	return base.get_tree().get_root().get_node(nodeName)

func get_node_by_nodepath(base: Node, nodePath: NodePath) -> Node:
	if not nodePath:
		printerr("Error: No node path for callable resource of name: '%s'" % [resource_name])
		return null
	return base.get_node(nodePath)

func check_node_callable(node: Node, callableName: String) -> Node:	
	if not node:
		printerr("Error: No node has been found for callable resource of of name: '%s'" % [resource_name])
		return null
	
	if not callableName in node:
		printerr("Error: No method/signal of name '%s' for callable resource of name: '%s'" % [resource_name])
		return null
	
	return node
