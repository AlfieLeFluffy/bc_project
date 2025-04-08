class_name CallableResource extends Resource

enum NODE_TYPE {DYNAMIC,STATIC}
enum CALLABLE_TYPE {METHOD,SIGNAL}

@export_category("Callable Information")
@export var nodeType: NODE_TYPE
@export var nodeName: String
@export var nodePath: NodePath
@export var callableType: CALLABLE_TYPE
@export var methodName: String
@export var signalName: String
@export var parameters: Array

func run(base: Node):
	if (nodeType == NODE_TYPE.DYNAMIC and not nodePath) or (nodeType == NODE_TYPE.STATIC and not nodeName):
		printerr("Error: No nodepath for callable resource of name: '%s'" % [resource_name])
		return null
		
	
	match callableType:
		CALLABLE_TYPE.METHOD:
			return await run_method(base)
		CALLABLE_TYPE.SIGNAL:
			return run_signal(base)
		_:
			printerr("Error: No callable type selected for callable resource of of name: '%s'" % [resource_name])
			return null

func run_method(base: Node):
	var node = check_callable(base, methodName)
	
	if not node:
		return null
	
	if not parameters:
		return node.call(methodName)
	else:
		return await node.callv(methodName,parameters)

func run_signal(base: Node):
	var node = check_callable(base, signalName)
	
	if not node:
		return null
		
	if not parameters:
		return node.emit_signal(signalName)
	else:
		return node.emit_signal(signalName,parameters)

func check_callable(base: Node, callableName: String) -> Node:
	if not callableName:
		printerr("Error: No method name for callable resource of name: '%s'" % [resource_name])
		return null
	
	var node
	match nodeType:
		NODE_TYPE.STATIC:
			node = base.get_tree().get_root().get_node(nodeName)
		NODE_TYPE.DYNAMIC:
			node = base.get_node(nodePath)
		_:
			printerr("Error: No node type selected for callable resource of of name: '%s'" % [resource_name])
			return null
	
	if not node:
		printerr("Error: No node has been found for callable resource of of name: '%s'" % [resource_name])
		return null
	
	if not callableName in node:
		printerr("Error: No method/signal of name '%s' for callable resource of name: '%s'" % [resource_name])
		return null
	
	return node
