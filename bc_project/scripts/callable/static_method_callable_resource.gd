class_name StaticMethodCallableResource extends CallableResource

@export_category("Callable Information")
@export var nodeName: String
@export var methodName: String

func run(base: Node):
	if not check_target_path(nodeName):
		return
	
	var node: Node = get_node_by_name(base, nodeName)
	node = check_node_callable(node,methodName)
	return await run_method(node,methodName)
