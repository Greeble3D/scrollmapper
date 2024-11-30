extends Line2D
class_name VXConnection

## The starting node of the connection.
var start_node: VXNode = null

## The ending node of the connection.
var end_node: VXNode = null

## The starting socket of the connection.
var start_socket: VXSocket = null

## The ending socket of the connection.
var end_socket: VXSocket = null

## Indicates if the connection is being edited.
var is_connection_being_edited: bool = false:
	set(new_value):
		if new_value == true:
			set_process(true)
		else:
			set_process(false)
		is_connection_being_edited = new_value

## Points per meter for the connection.
@export var points_per_meter: int = 10

## Initialization function
func initiate(start_socket: VXSocket, end_socket: VXSocket = null):	
	is_connection_being_edited = true
	self.start_socket = start_socket
	self.end_socket = end_socket
	get_starting_socket().socket_edit_ended.connect(_on_editing_ended)
	establish_starting_connection_points()

## Process function
func _process(delta: float) -> void:
	update_connection_points_mouse_drag()

## The main function to connect sockets.
## This function fires after mouse-up on editing.
func do_socket_connections() -> void:
	end_socket = get_target_socket()
	is_connection_being_edited = false
	if not is_connection_route_valid():
		delete_connection()	
		return

	start_socket.connection = self
	end_socket.connection = self

	connect_signals()
	get_starting_socket().emit_new_connection_created(get_starting_socket(), get_ending_socket())
	get_ending_socket().emit_new_connection_created(get_starting_socket(), get_ending_socket())
	finalize_connection_points()

## Delete the connection
func delete_connection():
	if start_socket != null:
		start_socket.delete()
	if end_socket != null:
		end_socket.delete()
	start_socket = null
	end_socket = null
	start_node = null
	end_node = null
	queue_free()

## Signal connection function
func connect_signals():
	if not get_starting_socket().node_moved.is_connected(_on_socket_moved):
		get_starting_socket().node_moved.connect(_on_socket_moved)
	if not get_ending_socket().node_moved.is_connected(_on_socket_moved):
		get_ending_socket().node_moved.connect(_on_socket_moved)
	if not get_starting_socket().socket_updated.is_connected(_on_socket_updated):
		get_starting_socket().socket_updated.connect(_on_socket_updated)
	if not get_ending_socket().socket_updated.is_connected(_on_socket_updated):
		get_ending_socket().socket_updated.connect(_on_socket_updated)
	if not tree_exiting.is_connected(retire_connection):
		tree_exiting.connect(retire_connection)

#region socket editing

## Handle editing ended
func _on_editing_ended() -> void:
	do_socket_connections()



## Various checks to determine if the connection is valid.
func is_connection_route_valid() -> bool:
	# CASE: Node connected to self. Not going to work.
	if get_starting_socket() == get_ending_socket():
		print("Rejection: Node connected to self")
		return false
	# CASE: No target socket. Not going to work.
	if get_ending_socket() == null:
		print("Rejection: No target socket")
		return false
	# CASE: Socket combination is invalid; ie, input to input, output to output, etc.
	if not is_connection_valid(get_starting_socket(), get_ending_socket()):
		return false
	# CASE: Valid connection. Connect the sockets.
	if get_ending_socket() != null and get_starting_socket() != null:
		return true
	# CASE: Still unknown. Default false.
	print("Rejection: Unknown case")
	return false

## Validate connection based on socket types and directions
func is_connection_valid(start_sock: VXSocket, end_sock: VXSocket) -> bool:
	# Inputs cannot connect to inputs
	if start_sock.socket_type == Types.SocketType.INPUT and end_sock.socket_type == Types.SocketType.INPUT:
		print("Rejection: Inputs cannot connect to inputs")
		return false
	# Outputs cannot connect to outputs
	if start_sock.socket_type == Types.SocketType.OUTPUT and end_sock.socket_type == Types.SocketType.OUTPUT:
		print("Rejection: Outputs cannot connect to outputs")
		return false
	# Parallels cannot connect to linears
	if start_sock.socket_direction == Types.SocketDirectionType.PARALLEL and end_sock.socket_direction == Types.SocketDirectionType.LINEAR:
		print("Rejection: Parallels cannot connect to linears")
		return false
	# Linears cannot connect to parallels
	if start_sock.socket_direction == Types.SocketDirectionType.LINEAR and end_sock.socket_direction == Types.SocketDirectionType.PARALLEL:
		print("Rejection: Linears cannot connect to parallels")
		return false
	# Linears can connect to linears
	if start_sock.socket_direction == Types.SocketDirectionType.LINEAR and end_sock.socket_direction == Types.SocketDirectionType.LINEAR:
		return true
	# Parallels can connect to parallels
	if start_sock.socket_direction == Types.SocketDirectionType.PARALLEL and end_sock.socket_direction == Types.SocketDirectionType.PARALLEL:
		return true
	# Inputs can connect to outputs
	if start_sock.socket_type == Types.SocketType.INPUT and end_sock.socket_type == Types.SocketType.OUTPUT:
		return true
	# Outputs can connect to inputs
	if start_sock.socket_type == Types.SocketType.OUTPUT and end_sock.socket_type == Types.SocketType.INPUT:
		return true
	# Default case: invalid connection
	print("Rejection: Default case - invalid connection")
	return false

## Retire connection
func retire_connection():
	if start_socket != null:
		start_socket.queue_free()
	if end_socket != null:
		end_socket.queue_free()
	if start_node != null:
		start_node.update_sockets()
	if end_node != null:
		end_node.update_sockets()

## Handle socket moved
func _on_socket_moved(pos: Vector2) -> void:
	finalize_connection_points()

## Handle socket updated
func _on_socket_updated() -> void:
	finalize_connection_points()

## Get the starting socket
func get_starting_socket() -> VXSocket:
	return start_socket

## Get the ending socket
func get_ending_socket() -> VXSocket:
	return end_socket

## Get the target socket
func get_target_socket() -> VXSocket:
	if VXGraph.current_focused_socket != null:
		if VXGraph.current_focused_socket == self:
			return null
		return VXGraph.current_focused_socket
	return null

#endregion socket editing

#region connector points / line drawing

## Establish initial connection points
func establish_starting_connection_points():
	add_point(get_starting_socket().get_connection_point())
	add_point(get_global_mouse_position())

## Finalize connection points
func finalize_connection_points():
	if get_tree() == null:
		return
	await get_tree().process_frame
	set_point_position(get_start_point_index(), get_starting_socket().get_connection_point())
	set_point_position(get_end_point_index(), get_ending_socket().get_connection_point())
	start_node = get_starting_socket().get_connected_node()
	end_node = get_ending_socket().get_connected_node()

## Update connection points during mouse drag
func update_connection_points_mouse_drag():
	set_point_position(get_start_point_index(), get_start_point())
	set_point_position(get_end_point_index(), get_global_mouse_position())

## Returns the index of the starting point.
func get_start_point_index() -> int:
	return 0

## Returns the index of the ending point.
func get_end_point_index() -> int:	
	return points.size() - 1

## Returns the position of the first point.
func get_start_point() -> Vector2:
	return points[0]

## Returns the position of the last point.
func get_end_point() -> Vector2:
	return points[points.size() - 1]

#endregion connector points / line drawing
