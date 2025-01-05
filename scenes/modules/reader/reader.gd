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

var current_translation:String = "KJV"
var current_book:String = "Genesis"
var current_chapter:int = 1

var mininum_chapter:int = 1
var maximum_chapter:int = 1

func _ready() -> void:
	books_button.pressed.connect(show_reader_book_selector)
	reader_book_selector.book_chosen.connect(_on_book_chosen)
	previous_chapter_button.pressed.connect(previous_chapter)
	next_chapter_button.pressed.connect(next_chapter)
	hide_reader_book_selector()
	show_chapter("KJV", "Genesis", 1)
	hide_cross_referencing_browser()

func show_chapter(translation_abbr:String, book:String, chapter:int = 1) -> void:
	current_translation = translation_abbr
	current_book = book
	current_chapter = chapter
	var verses:Array = ScriptureService.get_verses(translation_abbr, book, chapter)
	clear_reading_browser()
	clear_cross_referencing_browser()
	populate_chapter_buttons()
	var chapter_heading:ReadingTitle = create_reading_title("%s %s [%s]" % [str(book), str(chapter), translation_abbr])
	reading_v_box_container.add_child(chapter_heading)
	for verse:Dictionary in verses:
		var reading_scripture:ReadingScripture = create_reading_scripture(verse)
		reading_v_box_container.add_child(reading_scripture)
	

func next_chapter() -> void:
	if current_chapter < maximum_chapter:
		current_chapter += 1
		show_chapter(current_translation, current_book, current_chapter)

func previous_chapter() -> void:
	if current_chapter > mininum_chapter:
		current_chapter -= 1
		show_chapter(current_translation, current_book, current_chapter)

func populate_chapter_buttons():
	clear_chapters_browser()
	var chapters:Dictionary = ScriptureService.get_all_chapter_numbers_in_book(current_translation, current_book )
	for chapter in chapters["chapters"]:
		var reader_chapter_button:ReaderChapterButton = create_reader_chapter_button(current_translation, current_book, chapter)
		chapters_v_box_container.add_child(reader_chapter_button)
	update_min_max_chapters_for_book(chapters["chapters"])

func update_min_max_chapters_for_book(chapters:Array) -> void:
	mininum_chapter = 10000
	maximum_chapter = 1
	for chapter in chapters:
		if chapter < mininum_chapter:
			mininum_chapter = chapter
		if chapter > maximum_chapter:
			maximum_chapter = chapter

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

func create_reading_scripture(verse:Dictionary) -> ReadingScripture:
	var rs:ReadingScripture = READING_SCRIPTURE.instantiate()
	rs.translation_id = verse["translation_id"]
	rs.translation_abbr = verse["translation_abbr"]
	rs.book_id = verse["book_id"]
	rs.book_name = verse["book_name"]
	rs.chapter = verse["chapter"]
	rs.verse = verse["verse"]
	rs.verse_id = verse["verse_id"]
	rs.verse_hash = verse["verse_hash"]
	rs.text = verse["text"]
	rs.title = verse["title"]
	rs.license = verse["license"]
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
	rcb.chapter_chosen.connect(show_chapter)
	return rcb
	
func _on_book_chosen(translation_abbr:String, book:String) -> void:
	show_chapter(translation_abbr, book, 1)
