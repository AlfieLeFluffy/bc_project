class_name DynamicMethodCallableResource extends CallableResource

@export_category("Callable Information")
@export var nodePath: NodePath
@export var methodName: String

func run(base: Node):
	if not check_target_path(nodePath):
		return
	
	var node: Node = get_node_by_nodepath(base, nodePath)
	node = check_node_callable(node,methodName)
	return await run_method(node,methodName)
