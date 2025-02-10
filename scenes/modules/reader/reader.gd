extends Control

class_name Reader

const READING_SCRIPTURE = preload("res://scenes/modules/reader/reading_scripture/reading_scripture.tscn")
const READING_TITLE = preload("res://scenes/modules/reader/reading_title/reading_title.tscn")
const READER_CHAPTER_BUTTON = preload("res://scenes/modules/reader/reader_chapter_button/reader_chapter_button.tscn")

@export var books_button: Button 
@export var previous_chapter_button: Button 
@export var cross_refs_button: Button 
@export var next_chapter_button: Button 

@export var browser_margin_container: MarginContainer 
@export var chapters_v_box_container: VBoxContainer 
@export var reading_v_box_container: VBoxContainer 
@export var cross_referencing_margin_container: MarginContainer
@export var cross_referencing_v_box_container: VBoxContainer
@export var reader_book_selector: ReaderBooksSelector

@export var chapers_scroll_container: ScrollContainer 
@export var reading_scroll_container: ScrollContainer 
@export var cross_referencing_scroll_container: ScrollContainer 

@export var distraction_free_button: Button 
@export var font_size_spin_box: SpinBox 

var original_font_size:float = 20

var current_translation:String = "KJV"
var current_book:String = "Genesis"
var current_chapter:int = 1

var minimum_chapter:int = 1
var maximum_chapter:int = 1

func _ready() -> void:
	ScriptureService.verse_cross_references_searched.connect(_on_cross_references_received)
	books_button.pressed.connect(show_reader_book_selector)
	reader_book_selector.book_chosen.connect(_on_book_chosen)
	cross_refs_button.pressed.connect(toggle_cross_references)
	previous_chapter_button.pressed.connect(previous_chapter)
	next_chapter_button.pressed.connect(next_chapter)	
	distraction_free_button.toggled.connect(_on_distraction_free_button_toggled)
	font_size_spin_box.value_changed.connect(_on_font_size_spin_box_changed)
	font_size_spin_box.value = 20
	original_font_size = get_font_size()
	hide_reader_book_selector()
	show_chapter("KJV", "Genesis", 1)
	hide_cross_referencing_browser()

func _exit_tree() -> void:
	# Font size should be reset to original size on exit. 
	set_font_size(original_font_size)

## Show the chapter for the given translation, book, and chapter
## The main chapter display function. Use it for the reader from any 
## other chapter-display need.
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
	reading_scroll_container.scroll_vertical = 0

## Show the next chapter
func next_chapter() -> void:
	if current_chapter < maximum_chapter:
		current_chapter += 1
		show_chapter(current_translation, current_book, current_chapter)

## Show the previous chapter
func previous_chapter() -> void:
	if current_chapter > minimum_chapter:
		current_chapter -= 1
		show_chapter(current_translation, current_book, current_chapter)

## Populate the chapter buttons
func populate_chapter_buttons():
	clear_chapters_browser()
	var chapters:Dictionary = ScriptureService.get_all_chapter_numbers_in_book(current_translation, current_book )
	for chapter in chapters["chapters"]:
		var reader_chapter_button:ReaderChapterButton = create_reader_chapter_button(current_translation, current_book, chapter)
		chapters_v_box_container.add_child(reader_chapter_button)
	update_min_max_chapters_for_book(chapters["chapters"])
	chapers_scroll_container.scroll_vertical = 0

## Update the minimum and maximum chapters for the current book
func update_min_max_chapters_for_book(chapters:Array) -> void:
	minimum_chapter = 10000
	maximum_chapter = 1
	for chapter in chapters:
		if chapter < minimum_chapter:
			minimum_chapter = chapter
		if chapter > maximum_chapter:
			maximum_chapter = chapter

## Request cross-references for the given translation, book, chapter, and verse
func request_cross_references(_translation:String, _book_name:String, _chapter:int, _verse:int) -> void:
	ScriptureService.request_cross_references(_translation, _book_name, _chapter, _verse)

func _on_cross_references_received(cross_references:Array) -> void:
	clear_cross_referencing_browser()
	for cross_reference in cross_references:
		var reading_scripture:ReadingScripture = create_reading_scripture(cross_reference)
		reading_scripture.convert_to_cross_reference()
		cross_referencing_v_box_container.add_child(reading_scripture)
	show_cross_referencing_browser()
	cross_referencing_scroll_container.scroll_vertical = 0

## Toggle the cross-referencing container
func toggle_cross_references() -> void:
	if cross_referencing_margin_container.visible:
		hide_cross_referencing_browser()
	else:
		show_cross_referencing_browser()

## Show the reader
func show_reader_book_selector() -> void:
	reader_book_selector.show()

## Hide the reader
func hide_reader_book_selector() -> void:
	reader_book_selector.hide()

## Clear the chapters browser
func clear_chapters_browser() -> void:
	for child in chapters_v_box_container.get_children():
		child.queue_free()

## Clear the reading browser
func clear_reading_browser() -> void:
	for child in reading_v_box_container.get_children():
		child.queue_free()

## Clear the cross-referencing browser
func clear_cross_referencing_browser() -> void:
	for child in cross_referencing_v_box_container.get_children():
		child.queue_free()

## Hide the cross-referencing browser
func hide_cross_referencing_browser():
	cross_referencing_margin_container.hide()

## Show the cross-referencing browser
func show_cross_referencing_browser():
	cross_referencing_margin_container.show()

func hide_chapters_browser() -> void:
	browser_margin_container.hide()
	
func show_chapters_browser() -> void:
	browser_margin_container.show()

## Create a reading scripture object
## This is the scripture for reading.
## It is for reading a scripture.
## More documentation here: https://www.youtube.com/watch?v=CLeJ-tZBqKY 
func create_reading_scripture(verse:Dictionary) -> ReadingScripture:
	var rs:ReadingScripture = READING_SCRIPTURE.instantiate()
	rs.translation_id = verse["translation_id"]
	rs.translation_abbr = verse["translation_abbr"]
	rs.book_id = verse["book_id"]
	rs.book_name = verse["book_name"]
	rs.chapter = verse["chapter"]
	rs.verse = verse["verse"]
	rs.verse_id = verse["verse_id"]
	#rs.verse_hash = verse["verse_hash"]
	rs.text = verse["text"]
	rs.title = verse["title"]
	rs.license = verse["license"]
	rs.scripture_pressed.connect(request_cross_references)
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

func _on_distraction_free_button_toggled(toggled:bool) -> void:
	if toggled:
		hide_chapters_browser()
	else:
		show_chapters_browser()
		

func get_font_size() -> float:
	var default_font := get_theme_default_font()
	if default_font:
		return default_font.fixed_size 
	return 20
		

func set_font_size(value:float) -> void:
	var default_font := get_theme_default_font()
	if default_font:
		default_font.fixed_size = int(value)
		self.add_theme_font_override("font", default_font)

func _on_font_size_spin_box_changed(value:float) -> void:
	set_font_size(value)
