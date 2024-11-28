extends TextureRect
class_name VXSocket

var socket_type: Types.SocketType
var socket_direction: Types.SocketDirectionType

var connected_node: VXNode

func set_socket_type(socket_type: Types.SocketType):
	self.socket_type = socket_type

func set_direction_type(direction_type: Types.SocketDirectionType):
	self.socket_direction = direction_type
