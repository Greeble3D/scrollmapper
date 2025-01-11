extends MarginContainer

class_name MetaKeyBrowserOption

var meta_key:String = "":
	set(value):
		meta_key = value
		meta_key_button.text = value

var is_verse_meta:bool = false
var is_book_meta:bool = false
var is_translation_meta:bool = false

@export var meta_key_button: Button 
@export var meta_key_delete_button: Button 

signal meta_key_chosen(meta_key:String, meta_type:String)
signal delete_meta_key_chosen(meta_key:String, meta_type:String)

func _ready() -> void:
	meta_key_button.pressed.connect(_on_meta_key_button_pressed)
	meta_key_delete_button.pressed.connect(_on_meta_key_delete_button_pressed)

func _on_meta_key_button_pressed():
	meta_key_chosen.emit(meta_key, get_meta_type_string())
	
func _on_meta_key_delete_button_pressed():
	delete_meta_key_chosen.emit(meta_key, get_meta_type_string())

func get_meta_type_string() -> String:
	if is_verse_meta:
		return "verse"
	elif is_book_meta:
		return "book"
	elif is_translation_meta:
		return "translation"
	return "" # this line should never happen if previous steps done correctly
