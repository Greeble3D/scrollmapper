extends GridContainer

class_name BookListing

const BOOK_LISTING_INSTALLED = preload("res://scenes/modules/book_library/grid_elements/themes/book_listing_installed.tres")

## Will this be included into the database?
@export var include_checkbox: CheckBox 

## Book / translation 
@export var book_rich_text_label: RichTextLabel 

## Language of the book
@export var language_rich_text_label: RichTextLabel 

## Title of the book / translation 
@export var title_rich_text_label: RichTextLabel 

## Content type. Bible or Extrabiblical
@export var content_type_rich_text_label: RichTextLabel 

## Book / translation abbreviation
var book:String = "":
	set(value):
		book_rich_text_label.text = value
		book = value

## Language of the book
var language:String = "":
	set(value):
		language_rich_text_label.text = value
		language = value

## Title of the book / translation
var title:String = "":
	set(value):
		title_rich_text_label.text = truncate_text(value, 25)
		title_rich_text_label.tooltip_text = value
		title = value

## Content type. Bible or Extrabiblical
var content_type:String = "":
	set(value):
		content_type_rich_text_label.text = value
		content_type = value

var is_installed: bool = false
var is_selected: bool = false

## Signal to emit when the include checkbox is toggled
signal include_changed(include:bool)

func _ready() -> void:
	include_checkbox.pressed.connect(emit_include_changed)
	
## To be called after all variables are set up. If the book is already in the database, set the checkbox to true.
func set_current_status():
	if content_type == "bible":
		if ScriptureService.is_translation_installed(book):
			is_installed = true
	if content_type == "extrabiblical":
		if ScriptureService.is_book_installed("scrollmapper", title):
			is_installed = true
	if is_installed:
		var installed_theme:Theme = BOOK_LISTING_INSTALLED
		theme = installed_theme
		include_checkbox.set_pressed_no_signal(true)
		is_selected = true
	else:
		theme = null
	
## Emit the include_changed signal
func emit_include_changed() -> void:
	include_changed.emit(include_checkbox.toggled)
	is_selected = include_checkbox.button_pressed

## Truncate text to a specified number of characters and add "..." if truncated
func truncate_text(text: String, max_length: int) -> String:
	if text.length() > max_length:
		return text.substr(0, max_length) + "..."
	return text
