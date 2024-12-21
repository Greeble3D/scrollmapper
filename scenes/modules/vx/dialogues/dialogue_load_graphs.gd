extends MarginContainer

class_name LoadGraphsDialogue

@export var vx_editor:VXEditor
@export var item_list: ItemList 
@export var close_button: Button 

var options_key:Dictionary = {}

signal graph_selected(graph_id:int)

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	close_button.pressed.connect(hide)
	item_list.item_selected.connect(_on_item_selected)

func _on_visibility_changed() -> void:
	if visible:
		load_graph_list()
	else:
		clear()
		vx_editor.close_all_dialogues()

func load_graph_list()->void:
	clear()
	var graph_list:Array = VXService.get_graph_list()
	
	for graph in graph_list:
		var node_amount:int = VXService.get_graph_node_amount(graph["id"])
		if graph["graph_name"].is_empty():
			graph["graph_name"] = "<Unnamed Graph>"
		if graph["graph_description"].is_empty():
			graph["graph_description"] = "<No Description>"
		var label:String = "%s [%s]" % [graph["graph_name"], str(node_amount)]
		var list_id:int = item_list.add_item(label)
		options_key[list_id] = graph["id"]

func clear() -> void:
	item_list.clear()
	options_key.clear()

func _on_item_selected(id:int) -> void:
	graph_selected.emit(options_key[id])
	hide()
