extends CanvasLayer
class_name VXEditor

@export var vx_graph:VXGraph
@export var vx_camera_2d: Camera2D
@export var vx_search_and_execute: MarginContainer 
@export var cursor:TextureRect


var drag_start_position: Vector2 = Vector2()
var is_dragging: bool = false
var is_dragging_allowed: bool = false

func _ready():
	UserInput.double_clicked.connect(_on_mouse_double_clicked)
	UserInput.mouse_drag_started.connect(_on_mouse_drag_started)
	UserInput.mouse_drag_ended.connect(_on_mouse_drag_ended)

	UserInput.mouse_wheel_increased.connect(_on_mouse_wheel_increased)
	UserInput.mouse_wheel_decreased.connect(_on_mouse_wheel_decreased)

func _on_mouse_wheel_increased():
	vx_camera_2d.zoom *= 1.1

func _on_mouse_wheel_decreased():
	vx_camera_2d.zoom *= 0.9

func _on_mouse_drag_started(position: Vector2):
	set_process(true)
	if is_mouse_over_any_element():
		is_dragging_allowed = false
		return
	drag_start_position = position
	is_dragging = true

func _on_mouse_drag_ended(position: Vector2):
	set_process(false)
	is_dragging = false
	is_dragging_allowed = true

func _process(delta: float):
	if is_dragging:
		var mouse_position: Vector2 = get_viewport().get_mouse_position()
		var offset: Vector2 = mouse_position - drag_start_position
		drag_start_position = mouse_position
		
		# Check if the mouse is over a node or socket
		if not is_mouse_over_any_element():
			vx_camera_2d.position -= offset

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
	var final_position:Vector2 = position - cursor.size / 2
	cursor.global_position = final_position

func get_cursor_position() -> Vector2:
	return cursor.global_position

func _on_vx_graph_ready() -> void:
	set_cursor_position(Vector2.ZERO)

func _on_mouse_double_clicked():
	if is_mouse_over_any_element():
		return
	var mouse_position:Vector2 = vx_graph.get_global_mouse_position()
	set_cursor_position(mouse_position)
