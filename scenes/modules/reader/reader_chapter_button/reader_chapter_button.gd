extends Button

class_name ReaderChapterButton

var translation:String = ""
var book:String = ""
var chapter:int = -1:
	set(value):
		chapter = value
		text = "Chapter %s"%str(value)

signal chapter_chosen(translation_abbr:String, book:String, chapter:int)

func _ready() -> void:
	pressed.connect(_on_chapter_chosen)

func _on_chapter_chosen() -> void:
	chapter_chosen.emit(translation, book, chapter)
