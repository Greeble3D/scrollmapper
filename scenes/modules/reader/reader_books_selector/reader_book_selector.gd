extends MarginContainer

class_name ReaderBooksSelector 

const READER_TRANSLATION_CONTAINER = preload("res://scenes/modules/reader/reader_books_selector/reader_translation_container/reader_translation_container.tscn")

@export var translation_v_box_container: VBoxContainer 

signal book_chosen(translation_abbr:String, book:String)

func _ready() -> void:
	clear_translation_v_box_container()
	UserInput.escape_key_pressed.connect(_hide_selector)
	populate_translations()
	book_chosen.connect(_on_book_chosen)

func populate_translations() -> void:
	var translations = ScriptureService.get_all_translations()
	for translation in translations:
		var rtc:ReaderTranslationContainer = create_reader_translation_container(translation)
		translation_v_box_container.add_child(rtc)
		rtc.book_chosen.connect(emit_book_chosen)

func _hide_selector() ->void:
	hide()

func clear_translation_v_box_container() -> void:
	for child in translation_v_box_container.get_children():
		child.queue_free()

func create_reader_translation_container(translation:Dictionary) -> ReaderTranslationContainer:
	var rtc:ReaderTranslationContainer = READER_TRANSLATION_CONTAINER.instantiate()
	rtc.inititate(translation["translation_abbr"], translation["title"], translation["license"])
	return rtc

func emit_book_chosen(_translation_abbr:String, book:String) -> void:
	book_chosen.emit(_translation_abbr, book)
	
func _on_book_chosen(_translation_abbr:String, book:String) -> void:
	hide()
