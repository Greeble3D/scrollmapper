extends Control

const PREVIEW = preload("res://tmp/preview.tscn")

func _ready():
	mouse_filter = Control.MOUSE_FILTER_PASS


func _get_drag_data(at_position: Vector2) -> Variant:
	print("_get_drag_data called")
	var preview = PREVIEW.instantiate()
	set_drag_preview(preview)
	return 1

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
	print("Dropped data")
