extends MarginContainer

class_name MetaControlDialogue

const META_ENTRY_VX = preload("res://scenes/modules/meta_editor/meta_elements/meta_entry_vx.tscn")

signal node_selected(node:VXNode)

@export var vx_graph:VXGraph
@export var vx_node_item_list: ItemList 
@export var close_button: Button 
@export var selected_node_info_rich_text_label: RichTextLabel 

@export var add_meta_key_line_edit: LineEdit 
@export var add_meta_value_line_edit: LineEdit
@export var add_meta_button: Button 

@export var delete_meta_line_edit: LineEdit 
@export var delete_meta_button: Button 

@export var meta_entries_v_box_container: VBoxContainer 

## Coordinates vx_node_item_list index to vx_nodes
var vx_node_item_list_key:Dictionary = {}
var current_selected_verse_hash:int = 0

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	vx_node_item_list.multi_selected.connect(_on_vx_node_item_list_item_selected)
	close_button.pressed.connect(hide)
	node_selected.connect(update_selected_node_info_rich_text_label)
	node_selected.connect(update_selected_node_meta)
	add_meta_button.pressed.connect(_on_add_meta_button_pressed)
	delete_meta_button.pressed.connect(_on_delete_meta_button_pressed)
	clear_meta_list()
	
func populate_node_list() -> void:
	clear_node_list()
	var node_list:Array = []
	for vx_node:VXNode in vx_graph.vx_nodes.values():		
		node_list.append(vx_node)
	
	node_list.sort_custom(Callable(self, "_sort_nodes_alphabetically"))
	
	var i:int = -1
	for node:VXNode in node_list:
		vx_node_item_list.add_item("%s - %s" % [node.get_verse_string_pretty(), node.get_verse_text_pretty()])
		i+=1
		vx_node_item_list.set_item_tooltip_enabled(i, false)
		vx_node_item_list_key[i]=node
		
func _sort_nodes_alphabetically(a:VXNode, b:VXNode) -> bool:
	return a.get_verse_string_pretty() < b.get_verse_string_pretty()

func clear_node_list() -> void:
	vx_node_item_list.clear()
	vx_node_item_list_key.clear()

func _on_vx_node_item_list_item_selected(index:int, selected:bool) -> void:
	node_selected.emit(vx_node_item_list_key[index])
	current_selected_verse_hash = vx_node_item_list_key[index].get_verse_hash()

func _on_visibility_changed() -> void:
	if visible:
		populate_node_list()
	else:
		clear_node_list()
		
func update_selected_node_info_rich_text_label(vx_node:VXNode) -> void:
	var updated_text:String = "[b]%s[/b]\n%s"%[vx_node.get_verse_string_pretty(), vx_node.text]
	selected_node_info_rich_text_label.text = updated_text

func update_selected_node_meta(vx_node:VXNode) -> void:
	populate_meta_list(vx_node.get_verse_hash())

func get_selected_nodes() -> Array[VXNode]:
	var selected_nodes:Array[VXNode] = []
	for idx:int in vx_node_item_list.get_selected_items():
		selected_nodes.append(vx_node_item_list_key[idx])
	return selected_nodes

func _on_add_meta_button_pressed() -> void:
	add_meta()

func add_meta() -> void:
	var selected_nodes:Array[VXNode] = get_selected_nodes()
	if selected_nodes.size() > 0:
		for node:VXNode in selected_nodes:
			add_meta_entry(node.get_verse_hash(), add_meta_key_line_edit.text.strip_edges(), add_meta_value_line_edit.text.strip_edges())
	populate_meta_list(current_selected_verse_hash)

func _on_delete_meta_button_pressed() -> void:
	delete_meta()

func delete_meta() -> void:
	var selected_nodes:Array[VXNode] = get_selected_nodes()
	if selected_nodes.size() > 0:
		for node:VXNode in selected_nodes:
			delete_meta_entry(node.get_verse_hash(), delete_meta_line_edit.text.strip_edges())
	populate_meta_list(current_selected_verse_hash)

func populate_meta_list(verse_hash:int) -> void:
	clear_meta_list()
	var meta_list: Array = ScriptureService.get_all_verse_meta(verse_hash)
	for meta:Dictionary in meta_list:
		var meta_entry_vx:MetaEntryVX = META_ENTRY_VX.instantiate()
		meta_entry_vx.initiate(meta)
		meta_entries_v_box_container.add_child(meta_entry_vx)

func add_meta_entry(verse_hash:int, key:String, value:String) -> void:
	ScriptureService.set_verse_meta(verse_hash, key.strip_edges(), value.strip_edges())
	populate_meta_list(verse_hash)

func delete_meta_entry(verse_hash:int, key:String) -> void:
	ScriptureService.delete_verse_meta(verse_hash, key.strip_edges())
	populate_meta_list(verse_hash)

func clear_meta_list() -> void:
	for child:MetaEntryVX in meta_entries_v_box_container.get_children():
		child.queue_free()
