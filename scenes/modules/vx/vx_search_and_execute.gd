extends MarginContainer

class_name VXSearchAndExute

## The main container for vx_* module specific searches.
## Utilizes the search module to provide a search bar for searching for nodes in the graph.


@export var menu_button_graph: MenuButton
@export var menu_button_import: MenuButton
@export var menu_button_export: MenuButton

## When an operation is selected, this signal will be emitted.
## The op_tag will be the tag of the operation selected.
signal operation_selected(op_tag:String)

func _ready() -> void:
	menu_button_graph.get_popup().id_pressed.connect(_on_menu_button_graph_pressed)
	menu_button_import.get_popup().id_pressed.connect(_on_menu_button_import_pressed)
	menu_button_export.get_popup().id_pressed.connect(_on_button_export_pressed)

func _on_menu_button_graph_pressed(id:int) -> void:
	match id:
		0:
			operation_selected.emit("graph_settings")
		1:
			operation_selected.emit("graph_save")
		2:
			operation_selected.emit("graph_load")
		3:
			operation_selected.emit("graph_delete")
		4:
			operation_selected.emit("graph_new")
		5: 
			operation_selected.emit("exit")

func _on_menu_button_import_pressed(id:int) -> void:
	match id:
		0:
			# Import graph from json
			operation_selected.emit("import_vx_from_json")


func _on_button_export_pressed(id:int) -> void:
	match id:
		0:
			operation_selected.emit("export_vx_to_cross_references")
		1:
			operation_selected.emit("export_vx_to_gephi")
		2:
			operation_selected.emit("export_cross_references_to_gephi")
		3:
			operation_selected.emit("export_cross_references_to_json")
