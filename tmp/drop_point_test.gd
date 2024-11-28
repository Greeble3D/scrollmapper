extends TextureRect

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var vx_node:VXNode = data
	vx_node.position = position + at_position + vx_node.placement_offset
	vx_node.show_node()
