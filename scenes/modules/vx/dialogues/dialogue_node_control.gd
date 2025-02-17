extends MarginContainer

class_name DialogueNodeControl

const META_ENTRY_VX = preload("res://scenes/modules/meta_editor/meta_elements/meta_entry_vx.tscn")

@export var vx_editor: VXEditor
@export var scripture_location_rich_text_label: RichTextLabel 
@export var scripture_text_rich_text_label: RichTextLabel
@export var cross_reference: MarginContainer

#region Node Info
@export var connections_v_box_container: VBoxContainer 
#endregion 

#region Meta Management
@export var meta_list_v_box_container: VBoxContainer 
@export var meta_key_add_line_edit: LineEdit 
@export var meta_value_add_line_edit: LineEdit 
@export var meta_add_button: Button 
#endregion 

@export var close_button: Button 

static var is_dialogue_node_control_open: bool = false

var node: VXNode = null

#region Mirrored from VerseModel
var translation:String = ""
var book:String = ""
var chapter:int = 0
var verse:int = 0
var verse_hash:int = 0
#endregion 

@export_category("Connection Colors")
@export var top_connections_color:Color
@export var bottom_connections_color:Color
@export var left_connections_color:Color
@export var right_connections_color:Color

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	close_button.pressed.connect(close)
	cross_reference.option_pressed.connect(close)
	meta_add_button.pressed.connect(_on_meta_add_button_pressed)

func initiate(vx_node: VXNode) -> void:
	node = vx_node
	setup_scripture_variables()
	setup_scripture_text()
	setup_cross_references()
	populate_node_connections()
	populate_meta_list()	

func setup_scripture_variables() -> void:
	translation = node.translation
	book = node.book
	chapter = node.chapter
	verse = node.verse
	verse_hash = ScriptureService.get_verse_hash(book, chapter, verse)

func setup_scripture_text() -> void:
	var location_template: String = "%s %s:%s (%s)"
	var location: String = location_template % [node.book, str(node.chapter), str(node.verse), node.translation]
	scripture_location_rich_text_label.text = location
	scripture_text_rich_text_label.text = node.text

func setup_cross_references() -> void:
	ScriptureService.request_cross_references(node.translation, node.book, node.chapter, node.verse)

func _on_visibility_changed() -> void:
	if visible:
		is_dialogue_node_control_open = true
	else:
		is_dialogue_node_control_open = false

func populate_node_connections() -> void:
	clear_node_connection_list()
	var connected_nodes:Dictionary = node.get_connected_nodes()
	var connected_nodes_top_amount:int = connected_nodes["top"].size()
	var connected_nodes_bottom_amount:int = connected_nodes["bottom"].size()
	var connected_nodes_left_amount:int = connected_nodes["left"].size()
	var connected_nodes_right_amount:int = connected_nodes["right"].size()
	# Initialize the tree
	var tree:Tree = Tree.new()
	var root = tree.create_item()
	root.set_text(0, node.get_verse_string_pretty()+ " Node Connections")
	
	# Connection Groups (Top, Bottom, Left, Right)
	var top_group:TreeItem = tree.create_item(root)
	top_group.set_text(0, "Top Connections [Linear, Input] (%d)" % connected_nodes_top_amount)
	top_group.set_custom_color(0, top_connections_color)
	top_group.collapsed = true

	var bottom_group:TreeItem = tree.create_item(root)
	bottom_group.set_text(0, "Bottom Connections [Linear, Output] (%d)" % connected_nodes_bottom_amount)
	bottom_group.set_custom_color(0, bottom_connections_color)
	bottom_group.collapsed = true

	var left_group:TreeItem = tree.create_item(root)
	left_group.set_text(0, "Left Connections [Parallel, Input] (%d)" % connected_nodes_left_amount)
	left_group.set_custom_color(0, left_connections_color)
	left_group.collapsed = true

	var right_group:TreeItem = tree.create_item(root)
	right_group.set_text(0, "Right Connections [Parallel, Output] (%d)" % connected_nodes_right_amount)
	right_group.set_custom_color(0, right_connections_color)
	right_group.collapsed = true

	# Set up the connections log...	
	for top_node in connected_nodes["top"]:
		var item: TreeItem = tree.create_item(top_group)
		item.set_text(0, top_node.get_verse_string_pretty())
		item.collapsed = true
		var child_item: TreeItem = tree.create_item(item)
		child_item.set_text(0, top_node.get_verse_text_pretty())

	for bottom_node in connected_nodes["bottom"]:
		var item: TreeItem = tree.create_item(bottom_group)
		item.set_text(0, bottom_node.get_verse_string_pretty())
		item.collapsed = true
		var child_item: TreeItem = tree.create_item(item)
		child_item.set_text(0, bottom_node.get_verse_text_pretty())

	for left_node in connected_nodes["left"]:
		var item: TreeItem = tree.create_item(left_group)
		item.set_text(0, left_node.get_verse_string_pretty())
		item.collapsed = true
		var child_item: TreeItem = tree.create_item(item)
		child_item.set_text(0, left_node.get_verse_text_pretty())

	for right_node in connected_nodes["right"]:
		var item: TreeItem = tree.create_item(right_group)
		item.set_text(0, right_node.get_verse_string_pretty())
		item.collapsed = true
		var child_item: TreeItem = tree.create_item(item)
		child_item.set_text(0, right_node.get_verse_text_pretty())

	connections_v_box_container.add_child(tree)
	tree.set_v_size_flags(Control.SIZE_EXPAND_FILL)

func clear_node_connection_list() -> void:
	for child in connections_v_box_container.get_children():
		child.queue_free()

func populate_meta_list() -> void:
	clear_meta_list()
	var meta_list: Array = ScriptureService.get_all_verse_meta(verse_hash)
	for meta:Dictionary in meta_list:
		var meta_entry_vx:MetaEntryVX = META_ENTRY_VX.instantiate()
		meta_entry_vx.initiate(meta)
		meta_list_v_box_container.add_child(meta_entry_vx)

func add_meta_entry(key:String, value:String) -> void:
	ScriptureService.set_verse_meta(verse_hash, key, value)
	populate_meta_list()

func clear_meta_list() -> void:
	for child in meta_list_v_box_container.get_children():
		child.queue_free()

func _on_meta_add_button_pressed() -> void:
	var key:String = meta_key_add_line_edit.text
	var value:String = meta_value_add_line_edit.text
	if key.is_empty():
		return
	add_meta_entry(key, value)
	meta_key_add_line_edit.text = ""
	meta_value_add_line_edit.text = ""

func close() -> void:
	vx_editor.close_all_dialogues()

static func is_open() -> bool:
	return is_dialogue_node_control_open
