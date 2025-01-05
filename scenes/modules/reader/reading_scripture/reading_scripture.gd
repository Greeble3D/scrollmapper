extends MarginContainer

class_name ReadingScripture

var verse_id: int = -1
var verse_hash: int = -1
var book_id: int = -1
var chapter: int = -1
var verse: int = -1:
	set(value):
		verse = value
		set_verse_number(value)		
var text: String = "":
	set(value):
		text = value
		set_verse_text(value)		
var book_name: String = ""
var translation_id: int = -1
var translation_abbr: String = ""
var title: String = ""
var license: String = ""

@export var verse_number_text_rich_text_label: RichTextLabel 
@export var text_rich_text_label: RichTextLabel

func set_verse_number(verse_number:int) -> void:
	verse_number_text_rich_text_label.text = str(verse_number)

func set_verse_text(text:String) -> void:
	text_rich_text_label.text = text
