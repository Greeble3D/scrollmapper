extends Control
class_name VXCanvas

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var vx_node: VXNode = data
	vx_node.move_node(at_position + vx_node.placement_offset)
