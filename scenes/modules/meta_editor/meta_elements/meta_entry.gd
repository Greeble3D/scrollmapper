extends MarginContainer

class_name MetaEntry

@export var meta_key_rich_text_label: RichTextLabel 
@export var meta_value_rich_text_label: RichTextLabel 
@export var meta_key_search_button: Button
@export var meta_delete_button: Button 

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
var meta_type:String = "verse"

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
