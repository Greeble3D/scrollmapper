extends MarginContainer

class_name MetaEntry

@export var meta_key_rich_text_label: RichTextLabel 
@export var meta_value_rich_text_label: RichTextLabel 
@export var meta_key_search_button: Button
@export var meta_delete_button: Button 
@export var background_panel: Panel 
@export var meta_type_rich_text_label: RichTextLabel
@export var translation_background_color:Color = Color.FIREBRICK
@export var book_background_color:Color = Color.WEB_GREEN
@export var verse_background_color:Color = Color.CORNFLOWER_BLUE

var label = ""

## Specifically the id in the database entry. 
var id:int 
## Example: attribute-new-testament
var meta_key:String:
	set(value):
		meta_key = value
		meta_key_rich_text_label.text = value
## Arbitrary string data for the value
var meta_value:String:
	set(value):
		meta_value = value
		meta_value_rich_text_label.text = value
## The verse hash that the meta entry is connected to.
var hash:int 
var meta_type:String = "verse":
	set(value):
		meta_type = value
		set_meta_type_style()

signal search_meta_key(meta_type:String, meta_key:String)
signal delete_meta_entry(meta_type:String, id:int)

func _ready() -> void:
	meta_key_search_button.pressed.connect(_on_meta_key_search_button_pressed)
	meta_delete_button.pressed.connect(_on_meta_delete_button_pressed)

func _on_meta_key_search_button_pressed():
	search_meta_key.emit(meta_type, meta_key)
	
func _on_meta_delete_button_pressed():
	delete_meta_entry.emit(meta_type, id)
	queue_free()

func set_meta_type_style()->void:
	var style_box_flat:StyleBoxFlat = background_panel.get_theme_stylebox("panel")
	match meta_type.to_lower():
		"translation":
			style_box_flat.bg_color = translation_background_color
			meta_type_rich_text_label.text = "Meta Type: Translation (%s)" % label
		"book":
			style_box_flat.bg_color = book_background_color
			meta_type_rich_text_label.text = "Meta Type: Book (%s)" % label
		"verse":
			style_box_flat.bg_color = verse_background_color
			meta_type_rich_text_label.text = "Meta Type: Verse (%s)" % label
		_:
			"Meta Type: -"
	
