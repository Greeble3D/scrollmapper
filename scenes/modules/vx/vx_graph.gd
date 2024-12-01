extends Node
class_name VXGraph

const VX_NODE = preload("res://scenes/modules/vx/vx_node.tscn")
const VX_CONNECTION = preload("res://scenes/modules/vx/vx_connection.tscn")

static var instance:VXGraph = null
static var current_focused_socket:VXSocket = null

func _ready():
	if VXGraph.instance == null:
		VXGraph.instance = self
	else:
		queue_free()
	ScriptureService.vx_verses_searched.connect(_on_vx_verses_searched)

func _exit_tree() -> void:
	VXGraph.instance = null

static func get_instance() -> VXGraph:
	return VXGraph.instance

func create_connection(start_socket:VXSocket, end_socket:VXSocket = null) -> VXConnection:
	var vx_connection:VXConnection = VX_CONNECTION.instantiate()
	add_child(vx_connection)
	vx_connection.initiate(start_socket, end_socket)	
	return vx_connection

func create_node() -> VXNode:
	var vx_node:VXNode = VX_NODE.instantiate()
	add_child(vx_node)
	return vx_node

## When the scripture service pushes a result, it will be caught here
## and a new node will be created. 
func _on_vx_verses_searched(results:Array):
	for result in results:
		var node = create_node()
		node.initiate(
			result["verse_id"],
			result["book_name"],
			result["chapter"],
			result["verse"],
			result["text"],
			result["translation_abbr"]
		)
