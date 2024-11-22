extends MarginContainer

@export var option_scope: OptionButton 
@export var option_translation: OptionButton 
@export var option_books: OptionButton 
@export var option_chapters: OptionButton
@export var search_input: LineEdit


func _ready():
	option_scope.item_selected.connect(_on_option_scope_item_selected)
	option_translation.item_selected.connect(_on_option_translation_item_selected)
	option_books.item_selected.connect(_on_option_books_item_selected)
	option_chapters.item_selected.connect(_on_option_chapters_item_selected)
	search_input.text_submitted.connect(_on_search_input_text_entered)
	
	# When options selected, update other options.
	option_translation.item_selected.connect(populate_book_options)
	option_books.item_selected.connect(populate_book_chapters)


	reset_scope_options()
	reset_translation_options()
	reset_book_options()
	reset_chapter_options()

	populate_translation_options()
	populate_book_options()
	populate_book_chapters()

func populate_translation_options(index:int = 0):
	reset_translation_options()
	var translations = ScriptureService.get_all_translations()
	for translation in translations:
		option_translation.add_item(translation["title"], translation["id"])

func populate_book_options(index:int = 0):
	reset_book_options()
	var selected_translation_id = option_translation.get_selected_id()
	if selected_translation_id == 0:
		return
	var translation:String = ScriptureService.get_translation_by_id(selected_translation_id)["translation_abbr"]
	var books = ScriptureService.get_all_books(translation)
	reset_book_options()
	for book in books:
		option_books.add_item(book["book_name"], book["id"])
	
	# Jumpstart the chapters
	populate_book_chapters()

func populate_book_chapters(index:int = 0):
	reset_chapter_options()
	var selected_translation_id = option_translation.get_selected_id()
	var selected_book_id = option_books.get_selected_id()
	var book = ScriptureService.get_book_by_id(selected_book_id)
	if book.is_empty():
		return
	var chapters = ScriptureService.get_all_chapter_numbers_in_book(book["translation"], book["book_name"])
	reset_chapter_options()
	
	for chapter in chapters["chapters"]:
		option_chapters.add_item(str(chapter), chapter)

func reset_scope_options():
	option_scope.clear()
	option_scope.add_item("All Scripture")
	option_scope.add_item("Common-Cannonical")
	option_scope.add_item("Extra-Cannonical")

func reset_translation_options():
	option_translation.clear()
	option_translation.add_item("-")

func reset_book_options():
	option_books.clear()
	option_books.add_item("-")
	reset_chapter_options()

func reset_chapter_options():
	option_chapters.clear()
	option_chapters.add_item("-")

func _on_option_scope_item_selected(index):
	print("Scope option selected: ", option_scope.get_item_text(index))

func _on_option_translation_item_selected(index):
	print("Translation option selected: ", option_translation.get_item_text(index))

func _on_option_books_item_selected(index):
	print("Books option selected: ", option_books.get_item_text(index))

func _on_option_chapters_item_selected(index):
	print("Chapters option selected: ", option_chapters.get_item_text(index))

func _on_search_input_text_entered(new_text):
	print("Search input text entered: ", new_text)
