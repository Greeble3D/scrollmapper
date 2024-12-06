extends Node
class_name VXGraph

const VX_NODE = preload("res://scenes/modules/vx/vx_node.tscn")
const VX_CONNECTION = preload("res://scenes/modules/vx/vx_connection.tscn")

static var instance:VXGraph = null
static var current_focused_socket:VXSocket = null

@export var vx_canvas:VXCanvas
@export var vx_editor:VXEditor
@export var camera_2d:Camera2D

## An important dictionary for tracking vx_nodes.
## {node_id: VXNode}
@export var vx_nodes:Dictionary = {}
## An important dictionary for tracking vx_connections.
## {connection_id: VXConnection}
@export var vx_connections:Dictionary = {}

func _ready():
	if VXGraph.instance == null:
		VXGraph.instance = self
	else:
		queue_free()
	ScriptureService.verses_searched.connect(_on_verses_searched)

func _exit_tree() -> void:
	VXGraph.instance = null

## Adds a node to the vx_nodes dictionary.
func add_vx_node(node: VXNode) -> void:
	if node == null:
		push_error("Cannot add a null node.")
		return
	if node.get_instance_id() in vx_nodes:
		push_error("Node is already added.")
		return
	vx_nodes[node.get_instance_id()] = node

## Removes a node from the vx_nodes dictionary.
func remove_vx_node(node: VXNode) -> void:
	if node == null:
		push_error("Cannot remove a null node.")
		return
	if node.get_instance_id() not in vx_nodes:
		push_error("Node is not found.")
		return
	vx_nodes.erase(node.get_instance_id())

## Adds a connection to the vx_connections dictionary.
func add_vx_connection(connection: VXConnection) -> void:
	if connection == null:
		push_error("Cannot add a null connection.")
		return
	if connection.get_instance_id() in vx_connections:
		push_error("Connection is already added.")
		return
	vx_connections[connection.get_instance_id()] = connection

## Removes a connection from the vx_connections dictionary.
func remove_vx_connection(connection: VXConnection) -> void:
	if connection == null:
		push_error("Cannot remove a null connection.")
		return
	if connection.get_instance_id() not in vx_connections:
		push_error("Connection is not found.")
		return
	vx_connections.erase(connection.get_instance_id())

## Gets the main 2d camera of the VX scene.
static func get_camera_2d()->Camera2D:
	return VXGraph.instance.camera_2d

## Gets the main VXGraph of the VX scene.
static func get_instance() -> VXGraph:
	return VXGraph.instance

## Creates a connection between two sockets.
func create_connection(start_socket:VXSocket, end_socket:VXSocket = null) -> VXConnection:
	var vx_connection:VXConnection = VX_CONNECTION.instantiate()
	vx_canvas.add_child(vx_connection)
	vx_connection.initiate(start_socket, end_socket)	
	return vx_connection

## Creates a node and adds it to the vx_canvas.
func create_node() -> VXNode:
	var vx_node:VXNode = VX_NODE.instantiate()
	vx_canvas.add_child(vx_node)
	return vx_node

## When the scripture service pushes a result, it will be caught here
## and a new node will be created. 
func _on_verses_searched(results:Array):
	for result in results:
		# Ensure the result has "work_space" and it is "vx".
		if not result.has("meta"):
			continue
		if not result["meta"].has("work_space"):
			continue
		if result["meta"]["work_space"] != "vx":
			continue
		var node:VXNode = create_node()
		node.initiate(
			result["verse_id"],
			result["book_name"],
			result["chapter"],
			result["verse"],
			result["text"],
			result["translation_abbr"]
		)
		await get_tree().process_frame
		node.move_node(vx_editor.get_cursor_position())
