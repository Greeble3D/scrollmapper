extends MarginContainer
class_name VXNode

# Main Attributes
@export_group("Main Attributes")
## The ID is the same found in the database.
@export var id: int
## The book of the Bible or collection.
@export var book: String
## The chapter of the verse.
@export var chapter: int
## The verse number.
@export var verse: int
## The text of the verse.
@export var text: String
## The translation of the Bible or collection.
@export var translation: String

# UI Elements
@export_group("UI Elements")
@export var verse_container: MarginContainer
@export var preview_text: RichTextLabel

# UI Elements / Icons
@export var primary_selection_icon:Control
@export var secondary_selection_icon:Control

# Socket Management
@export_group("Socket Management")
@export var sockets_mount_top: HBoxContainer
@export var sockets_mount_bottom: HBoxContainer 
@export var sockets_mount_left: VBoxContainer
@export var sockets_mount_right: VBoxContainer 

@export var sockets_top: Array[VXSocket] = []
@export var sockets_bottom: Array[VXSocket] = []
@export var sockets_left: Array[VXSocket] = []
@export var sockets_right: Array[VXSocket] = []

# Socket Dimensions
@export_group("Socket Dimensions")
@export var socket_dimensions: Vector2 = Vector2(40, 40)
@export var socket_padding: int = 40


# Signals
signal new_connection_created(start_socket: VXSocket, end_socket: VXSocket)
signal connection_deleted(socket:VXSocket)
signal node_selected(node: VXNode)
signal node_selected_plus(node:VXNode)
signal node_moved(new_position: Vector2)
signal node_dragged(new_position:Vector2)
signal sockets_updated

# Constants
const VX_NODE = preload("res://scenes/modules/vx/vx_node.tscn")
const VX_SOCKET = preload("res://scenes/modules/vx/vx_socket.tscn")

# Booleans
var is_mouse_over_node:bool = false
var dragging_already_in_progress:bool = false

var is_selected:bool = false:
	set(val):
		is_selected = val
		set_selected_state()

var is_selected_plus:bool = false:
	set(val):
		is_selected_plus = val
		set_selected_plus_state()

# Other Variables
var placement_offset: Vector2 = Vector2.ZERO
var last_set_global_position:Vector2 = Vector2.ZERO

## Is called from the setter is_selected:bool
## The purpose is to change whatever mechanisms are needed for the node's 
## selected state. The first use is to change the icon of the node.
func set_selected_state() ->void:
	if is_selected:
		primary_selection_icon.show()
	else:
		primary_selection_icon.hide()
		

## Is called from the setter is_selected_plus:bool
## The purpose is to change whatever mechanisms are needed for the node's
## selected state. The first use is to change the icon of the node.
func set_selected_plus_state() ->void:
	if is_selected_plus:
		secondary_selection_icon.show()
	else:
		secondary_selection_icon.hide()

# Lifecycle
func _ready():
	node_moved.connect(move_to_preview_node)
	update_sockets()
	new_connection_created.connect(update_sockets)
	connection_deleted.connect(update_sockets)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	UserInput.clicked.connect(select_node)
	UserInput.double_clicked.connect(arrange_connected_nodes)
	UserInput.click_released.connect(unselect_node_set)
	UserInput.click_released.connect(log_last_set_global_position)
	UserInput.shift_clicked.connect(select_node_multiple)
	UserInput.right_clicked.connect(delete_node)
	UserInput.mouse_dragged.connect(drag_node)
	UserInput.mouse_drag_ended.connect(_mouse_drag_ended_any_node)



# Initialization 
func initiate(id: int, book: String, chapter: int, verse: int, text: String, translation: String):
	self.id = id
	self.book = book
	self.chapter = chapter
	self.verse = verse
	self.text = text
	self.translation = translation
	set_preview_text()
	# Now add the node to the VXGraph vx_nodes dictionary...
	VXGraph.get_instance().add_vx_node(self)
	last_set_global_position = global_position
	set_selected_state()
	set_selected_plus_state()

## Function to get the node as a dictionary.
## Used in saving the node to the database.
func get_as_dictionary() -> Dictionary:
	return {
		"id": id,
		"book": book,
		"chapter": chapter,
		"verse": verse,
		"text": text,
		"translation": translation,
		"position_x": position.x,
		"position_y": position.y
	}

## Function to get all neighboring nodes.
## Used in mapping the graph.
func get_connected_nodes() -> Dictionary:
	var neighbors: Dictionary = {
		"top": [], # linear, input
		"bottom": [], # linear, output
		"left": [], # parallel, input
		"right": [], # parallel, output
	}
	for socket in sockets_top:
		if is_instance_valid(socket) and socket.connection != null:
			var neighbor: VXNode = socket.connection.get_other_node(self)
			if neighbor != null:
				neighbors["top"].append(neighbor)
	for socket in sockets_bottom:
		if is_instance_valid(socket) and socket.connection != null:
			var neighbor: VXNode = socket.connection.get_other_node(self)
			if neighbor != null:
				neighbors["bottom"].append(neighbor)
	for socket in sockets_left:
		if is_instance_valid(socket) and socket.connection != null:
			var neighbor: VXNode = socket.connection.get_other_node(self)
			if neighbor != null:
				neighbors["left"].append(neighbor)
	for socket in sockets_right:
		if is_instance_valid(socket) and socket.connection != null:
			var neighbor: VXNode = socket.connection.get_other_node(self)
			if neighbor != null:
				neighbors["right"].append(neighbor)
	return neighbors

# Returns the verse string in the format "book-chapter-verse".
# This is used for human-readable reference to the verse and also in the 
# VXConnection class for generating a hash when creating the id.
func get_verse_string() -> String:
	return "%s-%s-%s" % [book.replace(" ", "_"), str(chapter), str(verse)]

func set_preview_text():
	preview_text.bbcode_text = "[b]%s %s:%s[/b] - %s" % [book, str(chapter), str(verse), text]

## Returns the VXNode instance id.
func get_node_id()->int:
	return id

## Delete the node. 
func delete_node():
	if not can_edit():
		return
	##First, remove the node from the VXGraph vx_nodes dictionary.
	VXGraph.get_instance().remove_vx_node(self)

	# Now remove connections.
	for socket in sockets_top:
		if is_instance_valid(socket) and socket.connection != null:
			socket.delete_connection()
	for socket in sockets_bottom:
		if is_instance_valid(socket) and socket.connection != null:
			socket.delete_connection()
	for socket in sockets_left:
		if is_instance_valid(socket) and socket.connection != null:
			socket.delete_connection()
	for socket in sockets_right:
		if is_instance_valid(socket) and socket.connection != null:
			socket.delete_connection()
	queue_free()

## Registers the node as selected via the signal which is heard by VXGraph.
## The node's selected state (true or false) is assigned by VXGraph.set_selected_node 
## for the sake of continuity. 
func select_node():
	if not can_edit() || is_selected:
		return
	node_selected.emit(self)

## Unselects the node set in VXGraph
func unselect_node_set() ->void:
	if not Input.is_key_pressed(KEY_SHIFT):
		VXGraph.get_instance().clear_selection_set()

## This function is called from the _mouse_drag_ended in UserInput
## Used in drag operations in VXGraph
func log_last_set_global_position() -> void:
	last_set_global_position = global_position

## Registers the node as selected via the signal which is heard by VXGraph.
func select_node_multiple(pos:Vector2):
	if not can_edit():
		return
	node_selected_plus.emit(self)	

func drag_node(pos: Vector2):
	if not can_edit():
		return
	var new_position: Vector2 = get_global_mouse_position() - size / 2 + placement_offset
	node_moved.emit(new_position)
	node_dragged.emit(pos)

# Node Movement
func move_node(pos: Vector2):
	position = pos
	show_node()
	node_moved.emit(pos)
	

func move_to_preview_node(pos: Vector2):
	position = pos + placement_offset

func emit_node_moved(pos: Vector2):
	node_moved.emit(pos)

# Visibility
func hide_node():
	hide()
	
func show_node():
	show()

# Connection Management
func emit_new_connection_created(start_socket: VXSocket, end_socket: VXSocket):
	new_connection_created.emit(start_socket, end_socket)

func emit_connection_deleted(socket:VXSocket) -> void:
	connection_deleted.emit(socket)

## Socket Distribution
## This function maintenances all of the sockets. Distributing them and removing unused ones,
## but ensures that at least one free socket is available for new connections.
func update_sockets(starting_socket: VXSocket = null, ending_socket: VXSocket = null):
	await get_tree().process_frame # Prevent race condition. If this is not here, the sockets will not be updated correctly.
	remove_invalid_sockets()
	discover_socket_dimensions()
	remove_extra_sockets_from_array(sockets_top)
	remove_extra_sockets_from_array(sockets_bottom)
	remove_extra_sockets_from_array(sockets_left)
	remove_extra_sockets_from_array(sockets_right)

	if empty_socket_required(sockets_top):
		set_socket(Types.SocketType.INPUT, Types.SocketDirectionType.LINEAR)
	if empty_socket_required(sockets_bottom):
		set_socket(Types.SocketType.OUTPUT, Types.SocketDirectionType.LINEAR)
	if empty_socket_required(sockets_left):
		set_socket(Types.SocketType.INPUT, Types.SocketDirectionType.PARALLEL)
	if empty_socket_required(sockets_right):
		set_socket(Types.SocketType.OUTPUT, Types.SocketDirectionType.PARALLEL)

	recalculate_socket_positions_and_node_dimensions()

func empty_socket_required(sockets: Array[VXSocket]) -> bool:
	var empty_connection_found: bool = false
	if sockets.size() == 0:
		return true
	for socket in sockets:
		if not is_instance_valid(socket):
			continue
		if socket.connection == null:
			empty_connection_found = true
			break
	return !empty_connection_found

func remove_extra_sockets_from_array(sockets: Array[VXSocket]):
	var unconnected_sockets: Array[VXSocket] = []
	for socket in sockets:
		if not is_instance_valid(socket):
			continue
		if socket.connection == null:
			unconnected_sockets.append(socket)
	
	while unconnected_sockets.size() > 1:
		var socket_to_remove = unconnected_sockets.pop_back()
		socket_to_remove.queue_free()
		sockets.erase(socket_to_remove)

func remove_invalid_sockets():
	for i in range(sockets_top.size() - 1, -1, -1):
		if not is_instance_valid(sockets_top[i]):
			sockets_top.remove_at(i)
	for i in range(sockets_bottom.size() - 1, -1, -1):
		if not is_instance_valid(sockets_bottom[i]):
			sockets_bottom.remove_at(i)
	for i in range(sockets_left.size() - 1, -1, -1):
		if not is_instance_valid(sockets_left[i]):
			sockets_left.remove_at(i)
	for i in range(sockets_right.size() - 1, -1, -1):
		if not is_instance_valid(sockets_right[i]):
			sockets_right.remove_at(i)

func delete_all_sockets():
	for socket in sockets_top:
		if is_instance_valid(socket):
			socket.queue_free()
	for socket in sockets_bottom:
		if is_instance_valid(socket):
			socket.queue_free()
	for socket in sockets_left:
		if is_instance_valid(socket):
			socket.queue_free()
	for socket in sockets_right:
		if is_instance_valid(socket):
			socket.queue_free()

func discover_socket_dimensions():
	var socket = create_socket(Types.SocketType.INPUT, Types.SocketDirectionType.LINEAR)
	socket_dimensions = socket.size
	socket.queue_free()	

func create_socket(socket_type: Types.SocketType, direction_type: Types.SocketDirectionType) -> VXSocket:
	var socket: VXSocket = VX_SOCKET.instantiate()
	socket.set_socket_type(socket_type)
	socket.set_direction_type(direction_type)
	socket.set_connected_node(self)

	if socket_type == Types.SocketType.INPUT and direction_type == Types.SocketDirectionType.LINEAR:
		sockets_mount_top.add_child(socket)
	elif socket_type == Types.SocketType.OUTPUT and direction_type == Types.SocketDirectionType.LINEAR:
		sockets_mount_bottom.add_child(socket)
	elif socket_type == Types.SocketType.INPUT and direction_type == Types.SocketDirectionType.PARALLEL:
		sockets_mount_left.add_child(socket)
	elif socket_type == Types.SocketType.OUTPUT and direction_type == Types.SocketDirectionType.PARALLEL:
		sockets_mount_right.add_child(socket)

	return socket

func set_socket(socket_type: Types.SocketType, direction_type: Types.SocketDirectionType) -> void:
	var socket: VXSocket = create_socket(socket_type, direction_type)
	socket.position = position
	if socket_type == Types.SocketType.INPUT and direction_type == Types.SocketDirectionType.LINEAR:
		sockets_top.append(socket)
	elif socket_type == Types.SocketType.INPUT and direction_type == Types.SocketDirectionType.PARALLEL:
		sockets_left.append(socket)
	elif socket_type == Types.SocketType.OUTPUT and direction_type == Types.SocketDirectionType.LINEAR:
		sockets_bottom.append(socket)
	elif socket_type == Types.SocketType.OUTPUT and direction_type == Types.SocketDirectionType.PARALLEL:
		sockets_right.append(socket)

func recalculate_socket_positions_and_node_dimensions():
	var sockets_top_count: int = sockets_top.size()
	var sockets_bottom_count: int = sockets_bottom.size()
	var sockets_left_count: int = sockets_left.size()
	var sockets_right_count: int = sockets_right.size()

	var top_socket_array_length: float = sockets_top_count * (socket_dimensions.x * 2)
	var bottom_socket_array_length: float = sockets_bottom_count * (socket_dimensions.x * 2) 
	var left_socket_array_length: float = sockets_left_count * (socket_dimensions.y * 2)
	var right_socket_array_length: float = sockets_right_count * (socket_dimensions.y * 2) 

	var top_socket_array_length_padded: float = top_socket_array_length + (socket_padding * 2)
	var bottom_socket_array_length_padded: float = bottom_socket_array_length + (socket_padding * 2)
	var left_socket_array_length_padded: float = left_socket_array_length + (socket_padding * 2)
	var right_socket_array_length_padded: float = right_socket_array_length + (socket_padding * 2)

	var minimum_horizontal_length: float = max(top_socket_array_length_padded, bottom_socket_array_length_padded)
	var minimum_vertical_length: float = max(left_socket_array_length_padded, right_socket_array_length_padded)

	if get_minimum_size().x < minimum_horizontal_length:
		size.x = minimum_horizontal_length
	if get_minimum_size().y < minimum_vertical_length:
		size.y = minimum_vertical_length

	sockets_updated.emit()

func can_edit() -> bool:
	return is_mouse_over_node && !dragging_already_in_progress

## This function is called from the _mouse_drag_ended in UserInput
## so that if we stop dragging over some other node, that node will
## not ignore a new drag operation. Connected from 	
## UserInput.mouse_drag_ended.connect(_mouse_drag_ended_any_node)
func _mouse_drag_ended_any_node(pos:Vector2):
	dragging_already_in_progress = false

func _on_mouse_entered() -> void:
	dragging_already_in_progress = UserInput.is_dragging
	is_mouse_over_node = true

func _on_mouse_exited() -> void:
	dragging_already_in_progress = UserInput.is_dragging
	is_mouse_over_node = false

# automatic node connections

func get_empty_socket(socket_type: Types.SocketType, direction_type: Types.SocketDirectionType) -> VXSocket:
	var sockets: Array[VXSocket] = []
	if socket_type == Types.SocketType.INPUT and direction_type == Types.SocketDirectionType.LINEAR:
		sockets = sockets_top
	elif socket_type == Types.SocketType.INPUT and direction_type == Types.SocketDirectionType.PARALLEL:
		sockets = sockets_left
	elif socket_type == Types.SocketType.OUTPUT and direction_type == Types.SocketDirectionType.LINEAR:
		sockets = sockets_bottom
	elif socket_type == Types.SocketType.OUTPUT and direction_type == Types.SocketDirectionType.PARALLEL:
		sockets = sockets_right

	for socket in sockets:
		if is_instance_valid(socket) and socket.connection == null:
			return socket

	# If no empty socket is found, return null
	return null

## This will arrange all connected nodes around its perimeter.
func arrange_connected_nodes()->void:
	select_node()
	VXGraph.get_instance().arrange_node_positions()

#endregion
