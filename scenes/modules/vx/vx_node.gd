extends MarginContainer
class_name VXNode

@export_group("Main Attributes")
@export var id: int
@export var book: String
@export var chapter: int
@export var verse: int
@export var text: String
@export var translation: String

signal node_moved(new_position: Vector2)
signal node_move_initiated(starting_position: Vector2)
signal node_selected(node: VXNode)
signal connection_created(start_node: VXNode, end_node: VXNode)

@export var verse_container: MarginContainer 
@export var preview_text: RichTextLabel 


@export var socket_mount: Control 
@export var sockets_top: Array[VXSocket] = []
@export var sockets_bottom: Array[VXSocket] = []
@export var sockets_left: Array[VXSocket] = []
@export var sockets_right: Array[VXSocket] = []

## The dimensions of the socket
@export var socket_dimensions:Vector2 = Vector2(40, 40)
## The padding at the beginning of the socket row and the end.
@export var socket_padding:int = 40

const VX_NODE = preload("res://scenes/modules/vx/vx_node.tscn")
const VX_SOCKET = preload("res://scenes/modules/vx/vx_socket.tscn")

## the offset of the drag preview
var placement_offset:Vector2 = Vector2.ZERO

func _ready():
	initialize_sockets()

func _initiate(id: int, book: String, chapter: int, verse: int, text: String, translation: String):
	self.id = id
	self.book = book
	self.chapter = chapter
	self.verse = verse
	self.text = text
	self.translation = translation


func _get_drag_data(at_position: Vector2) -> Variant:
	initiate_drag(at_position)
	return self

func initiate_drag(at_position: Vector2) -> void:
	hide_node()
	var offsetter:Control = Control.new()	
	var preview = VX_NODE.instantiate()	
	offsetter.add_child(preview)
	preview.position -= at_position
	placement_offset = preview.position
	node_move_initiated.emit(position)
	
	set_drag_preview(offsetter)
	
func move_node(pos:Vector2):
	position = pos
	show_node()
	node_moved.emit(pos)

func hide_node():
	hide()
	
func show_node():
	show()


func initialize_sockets():
	discover_socket_dimensions()
	# Randomize the sockets for testing purposes.

	var rng = RandomNumberGenerator.new()
	rng.randomize()	

	for i in range(rng.randi_range(1, 8)):
		set_socket(Types.SocketType.INPUT, Types.SocketDirectionType.LINEAR)
	for i in range(rng.randi_range(1, 8)):
		set_socket(Types.SocketType.INPUT, Types.SocketDirectionType.PARALLEL)
	for i in range(rng.randi_range(1, 8)):
		set_socket(Types.SocketType.OUTPUT, Types.SocketDirectionType.LINEAR)
	for i in range(rng.randi_range(1, 8)):
		set_socket(Types.SocketType.OUTPUT, Types.SocketDirectionType.PARALLEL)

	recalculate_socket_positions_and_node_dimensions()

#region socket distribution

## This function is used to discover the dimensions of the socket for use in future calculations of the distribution of sockets over the node.
func discover_socket_dimensions():
	var socket = create_socket(Types.SocketType.INPUT, Types.SocketDirectionType.LINEAR)
	socket_dimensions = socket.size
	socket.queue_free()	

## This function is used to create a socket and add it to the node.
func create_socket(socket_type: Types.SocketType, direction_type: Types.SocketDirectionType) -> VXSocket:
	var socket:VXSocket = VX_SOCKET.instantiate()
	socket.set_socket_type(socket_type)
	socket.set_direction_type(direction_type)
	socket_mount.add_child(socket)
	return socket

## This function is used to set the socket on the node.
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

## Socket positions establish the general size of the entire node in the scene.
## This function is run as changes occur to verify and update the size of the node and placement of sockets.
func recalculate_socket_positions_and_node_dimensions():
	# Get the number of sockets in each direction
	var sockets_top_count: int = sockets_top.size()
	var sockets_bottom_count: int = sockets_bottom.size()
	var sockets_left_count: int = sockets_left.size()
	var sockets_right_count: int = sockets_right.size()

	# Each socket is separated from the last by a space equal to it's own length with padding added on each side. 
	var top_socket_array_length:float = sockets_top_count * (socket_dimensions.x * 2)
	var bottom_socket_array_length:float = sockets_bottom_count * (socket_dimensions.x * 2) 
	var left_socket_array_length:float = sockets_left_count * (socket_dimensions.y * 2)
	var right_socket_array_length:float = sockets_right_count * (socket_dimensions.y * 2) 

	# The length of the socket array is then padded by the padding on each side.
	var top_socket_array_length_padded:float = top_socket_array_length + (socket_padding*2)
	var bottom_socket_array_length_padded:float = bottom_socket_array_length + (socket_padding*2)
	var left_socket_array_length_padded:float = left_socket_array_length + (socket_padding*2)
	var right_socket_array_length_padded:float = right_socket_array_length + (socket_padding*2)

	# This will be the minimum horizontal length before the text is considerd.
	var minimum_horizontal_length:float = max(top_socket_array_length_padded, bottom_socket_array_length_padded)
	# This will be the minimum vertical length before the text is considerd.
	var minimum_vertical_length:float = max(left_socket_array_length_padded, right_socket_array_length_padded)

	# If the socket combined dimensions are greater than the minimum length, then the length is updated.
	if get_minimum_size().x < minimum_horizontal_length:
		size.x = minimum_horizontal_length
	# If the socket combined dimensions are greater than the minimum length, then the length is updated.
	if get_minimum_size().y < minimum_vertical_length:
		size.y = minimum_vertical_length

	# Now that the length and width are established, we can position all of the sockets. 

	var center_point:Vector2 = Vector2(0, 0)
	
	var top_center:Vector2 = center_point + Vector2(0+socket_dimensions.x, -size.y/2)
	var bottom_center:Vector2 = center_point + Vector2(0+socket_dimensions.x, size.y/2)
	var left_center:Vector2 = center_point + Vector2(-size.x/2, 0+socket_dimensions.x)
	var right_center:Vector2 = center_point + Vector2(size.x/2, 0+socket_dimensions.x)

	# The sockets are centered on their respective edges.
	var offset:Vector2 = socket_dimensions/2
	for i in range(sockets_top_count):
		sockets_top[i].position = top_center + Vector2((i * socket_dimensions.x * 2) - top_socket_array_length/2, 0) - offset

	for i in range(sockets_bottom_count):
		sockets_bottom[i].position = bottom_center + Vector2((i * socket_dimensions.x * 2) - bottom_socket_array_length/2, 0) - offset

	for i in range(sockets_left_count):
		sockets_left[i].position = left_center + Vector2(0, (i * socket_dimensions.y * 2) - left_socket_array_length/2) - offset

	for i in range(sockets_right_count):
		sockets_right[i].position = right_center + Vector2(0, (i * socket_dimensions.y * 2) - right_socket_array_length/2) - offset
		
#endregion
