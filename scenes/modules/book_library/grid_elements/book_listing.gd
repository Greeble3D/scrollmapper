extends GridContainer

class_name BookListing

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

## Language of the book
var language:String = "":
	set(value):
		language_rich_text_label.text = value

## Title of the book / translation
var title:String = "":
	set(value):
		title_rich_text_label.text = value

## Content type. Bible or Extrabiblical
var content_type:String = "":
	set(value):
		content_type_rich_text_label.text = value

## Signal to emit when the include checkbox is toggled
signal include_changed(include:bool)

func _ready() -> void:
	include_checkbox.pressed.connect(emit_include_changed)
	

## Emit the include_changed signal
func emit_include_changed() -> void:
	include_changed.emit(include_checkbox.toggled)
