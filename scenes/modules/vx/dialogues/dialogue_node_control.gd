extends MarginContainer

@export var vx_editor: VXEditor
@export var scripture_location_rich_text_label: RichTextLabel 
@export var scripture_text_rich_text_label: RichTextLabel
@export var cross_reference: MarginContainer

@export var close_button: Button 

var node: VXNode = null

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	close_button.pressed.connect(close)

func initiate(vx_node: VXNode) -> void:
	node = vx_node
	setup_scripture_text()
	setup_cross_references()

func setup_scripture_text() -> void:
	var location_template: String = "%s %s:%s (%s)"
	var location: String = location_template % [node.book, str(node.chapter), str(node.verse), node.translation]
	scripture_location_rich_text_label.text = location
	scripture_text_rich_text_label.text = node.text

func setup_cross_references() -> void:
	ScriptureService.request_cross_references(node.translation, node.book, node.chapter, node.verse)

func _on_visibility_changed() -> void:
	if visible:
		pass
	else:
		pass

func close() -> void:
	vx_editor.close_all_dialogues()
