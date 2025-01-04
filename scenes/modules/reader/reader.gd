extends Control

class_name Reader

const READING_SCRIPTURE = preload("res://scenes/modules/reader/reading_scripture/reading_scripture.tscn")
const READING_TITLE = preload("res://scenes/modules/reader/reading_title/reading_title.tscn")
const READER_CHAPTER_BUTTON = preload("res://scenes/modules/reader/reader_chapter_button/reader_chapter_button.tscn")

@export var books_button: Button 
@export var previous_chapter_button: Button 
@export var next_chapter_button: Button 

@export var chapters_v_box_container: VBoxContainer 
@export var reading_v_box_container: VBoxContainer 
@export var cross_referencing_margin_container: MarginContainer
@export var cross_referencing_v_box_container: VBoxContainer

@export var reader_book_selector: ReaderBooksSelector

func _ready() -> void:
	books_button.pressed.connect(show_reader_book_selector)
	reader_book_selector.book_chosen.connect(_on_book_chosen)
	hide_reader_book_selector()
	
func show_reader_book_selector() -> void:
	reader_book_selector.show()

func hide_reader_book_selector() -> void:
	reader_book_selector.hide()

func clear_chapters_browser() -> void:
	for child in chapters_v_box_container.get_children():
		child.queue_free()

func clear_reading_browser() -> void:
	for child in reading_v_box_container.get_children():
		child.queue_free()

func clear_cross_referencing_browser() -> void:
	for child in cross_referencing_v_box_container.get_children():
		child.queue_free()

func hide_cross_referencing_browser():
	cross_referencing_margin_container.hide()

func show_cross_referencing_browser():
	cross_referencing_margin_container.show()

func create_reading_scripture(translation:String, book:String, chapter:int, verse:int) -> ReadingScripture:
	var rs:ReadingScripture = READING_SCRIPTURE.instantiate()
	rs.translation = translation
	rs.book = book
	rs.chapter = chapter
	rs.verse = verse
	return rs
	
func create_reading_title(title:String) -> ReadingTitle:
	var rt:ReadingTitle = READING_TITLE.instantiate()
	rt.title = title
	return rt

func create_reader_chapter_button(translation:String, book:String, chapter:int) -> ReaderChapterButton:
	var rcb:ReaderChapterButton = READER_CHAPTER_BUTTON.instantiate()
	rcb.translation = translation
	rcb.book = book
	rcb.chapter = chapter
	return rcb
	
func _on_book_chosen(translation_abbr:String, book:String) -> void:
	print(translation_abbr)
	print(book)
