extends Control
class_name VXSocket

# Variables
var socket_type: Types.SocketType
var socket_direction: Types.SocketDirectionType
var connection: VXConnection = null
var connected_node: VXNode = null
var is_mouse_over_socket = false
var is_socket_being_edited: bool = false:
	set(new_value):
		if new_value == true:
			socket_edit_started.emit()
		else:
			socket_edit_ended.emit()
		is_socket_being_edited = new_value

# Signals
signal new_connection_created(start_socket: VXSocket, end_socket: VXSocket)
signal node_moved(position: Vector2)
signal socket_updated
signal socket_edit_started
signal socket_edit_ended


# Functions
func _ready():
	UserInput.mouse_drag_started.connect(_on_editing_started)
	UserInput.mouse_drag_ended.connect(_on_editing_ended)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	new_connection_created.connect(notify_node_of_new_connection)
	


func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		pass # perhaps future use
	elif event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if UserInput.is_dragging:
				set_currently_editing(true)

# Socket Type and Direction
func set_socket_type(socket_type: Types.SocketType):
	self.socket_type = socket_type

func set_direction_type(direction_type: Types.SocketDirectionType):
	self.socket_direction = direction_type

# Set the connected node to the node supplied.
func set_connected_node(node: VXNode):
	connected_node = node
	if not connected_node.node_moved.is_connected(_on_node_moved):
		connected_node.node_moved.connect(_on_node_moved)
	if not connected_node.sockets_updated.is_connected(_on_socket_updated):
		connected_node.sockets_updated.connect(_on_socket_updated)

## Deletes the attached connection.
func get_connected_node() -> VXNode:
	return connected_node

## Deletes a connection and signals the event in the connected node.
func delete_connection():
	if connection != null:
		connection.delete_connection()

	delete()


## Delete this node.
func delete():
	if is_instance_valid(self):
		queue_free()
		var connected_node_reference:VXNode = connected_node
		connected_node_reference.emit_connection_deleted(self)

# Mouse Events
func _on_mouse_entered() -> void:
	VXGraph.current_focused_socket = self
	is_mouse_over_socket = true

func _on_mouse_exited() -> void:
	VXGraph.current_focused_socket = null
	is_mouse_over_socket = false

# Editing Status
func set_currently_editing(editing: bool):
	is_socket_being_edited = editing

func _on_editing_started(_start_position: Vector2):
	if not is_mouse_over_socket:
		return
	if connection != null:
		connection.queue_free()
		return
	set_currently_editing(true)
	create_new_connection()

func _on_editing_ended(_end_position: Vector2):
	if not is_socket_being_edited:
		return
	set_currently_editing(false)

# Connection Management
func create_new_connection() -> VXConnection:
	connection = VXGraph.get_instance().create_connection(self)
	return connection

func get_connection_point() -> Vector2:
	return global_position + Vector2(size.x / 2, size.y / 2)

# Signal Handlers
func _on_node_moved(pos: Vector2) -> void:
	node_moved.emit(pos)

func _on_socket_updated() -> void:
	socket_updated.emit()

func emit_new_connection_created(start_socket: VXSocket, end_socket: VXSocket):
	new_connection_created.emit(start_socket, end_socket)

func notify_node_of_new_connection(start_socket: VXSocket, end_socket: VXSocket):
	connected_node.emit_new_connection_created(start_socket, end_socket)
