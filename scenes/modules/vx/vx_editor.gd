extends CanvasLayer
class_name VXEditor

@export var vx_graph:VXGraph
@export var vx_camera_2d: Camera2D
@export var vx_search_and_execute: MarginContainer 
@export var cursor:TextureRect


var drag_start_position: Vector2 = Vector2()
var is_dragging: bool = false
var is_dragging_allowed: bool = false
var starting_drag_position: Vector2 = Vector2.ZERO
var starting_drag_position_global: Vector2 = Vector2.ZERO
func _ready():
	UserInput.double_clicked.connect(_on_mouse_double_clicked)
	UserInput.mouse_drag_started.connect(_on_mouse_drag_started)
	UserInput.mouse_drag_ended.connect(_on_mouse_drag_ended)

	UserInput.mouse_wheel_increased.connect(_on_mouse_wheel_increased)
	UserInput.mouse_wheel_decreased.connect(_on_mouse_wheel_decreased)

	UserInput.mouse_drag_started.connect(_on_drag_started)

func _on_mouse_wheel_increased():
	if VXGraph.is_graph_locked:
		return
	vx_camera_2d.zoom *= 1.1

func _on_mouse_wheel_decreased():
	if VXGraph.is_graph_locked:
		return
	vx_camera_2d.zoom *= 0.9

func _on_mouse_drag_started(position: Vector2):
	set_process(true)
	if is_mouse_over_any_element():
		is_dragging_allowed = false
		return
	if VXGraph.is_graph_locked:
		return
	drag_start_position = position
	is_dragging = true

func _on_mouse_drag_ended(position: Vector2):
	set_process(false)
	is_dragging = false
	is_dragging_allowed = true

func _process(_delta: float):
	if is_dragging:
		var mouse_position: Vector2 = get_viewport().get_mouse_position()
		var drag_offset: Vector2 = (mouse_position - drag_start_position) / vx_camera_2d.zoom
		drag_start_position = mouse_position
		
		# Check if the mouse is over a node or socket
		if not is_mouse_over_any_element():
			vx_camera_2d.position -= drag_offset

## Will return true of the mouse is over a VXNode or VXSocket
## Note: This implementation uses a loop, which can be improved to avoid relying on loops.
func is_mouse_over_any_element() -> bool:

	for node:VXNode in get_tree().get_nodes_in_group("nodes"):
		if node.is_mouse_over_node:
			return true
	for socket:VXSocket in get_tree().get_nodes_in_group("sockets"):
		if socket.is_mouse_over_socket:
			return true

	if get_viewport().get_mouse_position().y < vx_search_and_execute.size.y:
		return true
	return false

func get_camera_2d() -> Camera2D:
	return VXGraph.get_camera_2d()

func get_camera_center_point_to_global()->Vector2:
	var camera = get_camera_2d()
	var center_screen = Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2)
	return center_screen

func set_cursor_position(position:Vector2) -> void:
	if VXGraph.is_graph_locked:
		return
	var final_position:Vector2 = position - cursor.size / 2
	cursor.global_position = final_position

func get_cursor_position() -> Vector2:
	return cursor.global_position

func _on_vx_graph_ready() -> void:
	set_cursor_position(Vector2.ZERO)

func _on_mouse_double_clicked():
	if is_mouse_over_any_element():
		return
	if VXGraph.is_graph_locked:
		return
	var mouse_position:Vector2 = vx_graph.get_global_mouse_position()
	set_cursor_position(mouse_position)

func _on_drag_started(pos:Vector2) -> void:
	starting_drag_position = pos
	starting_drag_position_global = vx_camera_2d.get_global_mouse_position()
