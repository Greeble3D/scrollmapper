extends VBoxContainer

class_name ReaderTranslationContainer

const TRANSLATION_BOOK_SELECTION_BUTTON = preload("res://scenes/modules/reader/reader_books_selector/reader_translation_container/translation_book_selection_button/translation_book_selection_button.tscn")

var translation:String = ""
var translation_title:String = ""
var translation_license:String = ""

@export var select_translation_button: Button 
@export var select_translation_book_check_button: CheckButton 

@export var grid_container: GridContainer 

signal book_chosen(translation_abbr:String, book:String)

func _ready() -> void:
	hide_grid_container()
	select_translation_book_check_button.pressed.connect(_toggle_grid_container)

func inititate(_translation:String, _translation_title:String, _translation_license:String):
	translation = _translation
	translation_title = _translation_title
	translation_license = _translation_license
	var translation_name:String = "%s - %s" % [translation, translation_title]
	select_translation_button.text = translation_name
	select_translation_button.pressed.connect(_on_book_chosen.bind(translation, ""))
	populate_translation_book_buttons()

func populate_translation_book_buttons() -> void:
	show_grid_container()
	clear_grid_container()
	var books = ScriptureService.get_all_book_names_from_translation(translation)
	for book in books:
		var tbsb:TranslationBookSelectionButton = create_translation_book_selection_button(translation, translation_title, book)
		tbsb.initiate(translation, translation_title, book)
		grid_container.add_child(tbsb)
		tbsb.pressed.connect(_on_book_chosen.bind(tbsb.translation_abbrev, tbsb.book))
	hide_grid_container()

func _toggle_grid_container() -> void:
	if grid_container.is_visible():
		hide_grid_container()
	else:
		show_grid_container()

func clear_grid_container() -> void:
	for child in grid_container.get_children():
		child.queue_free()

func show_grid_container() -> void:
	grid_container.show()

func hide_grid_container() -> void:
	grid_container.hide()

func create_translation_book_selection_button(translation:String, translation_abbrev:String, book:String) -> TranslationBookSelectionButton:
	var tbsb:TranslationBookSelectionButton = TRANSLATION_BOOK_SELECTION_BUTTON.instantiate()
	tbsb.translation = translation
	tbsb.translation_abbrev = translation_abbrev
	tbsb.book = book
	return tbsb

func _on_book_chosen(translation_abbr:String, book:String) -> void:
	book_chosen.emit(translation_abbr, book)
