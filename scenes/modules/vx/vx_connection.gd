extends Node2D
class_name VXConnection

var start_node: VXNode
var end_node: VXNode

func _init(start_node: VXNode, end_node: VXNode):
	self.start_node = start_node
	self.end_node = end_node

func _draw():
	draw_line(start_node.rect_position, end_node.rect_position, Color(1, 1, 1), 2)
