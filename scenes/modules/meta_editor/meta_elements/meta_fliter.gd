extends HBoxContainer

## Used in the meta data system / interface.
## Since the translation, book, and verse checkboxes are used in 
## multiple areas, we've created one class for it.
class_name MetaFilter
@export var translation_check_box: CheckBox 
@export var book_check_box: CheckBox 
@export var verse_check_box: CheckBox 

var translation_included: bool = false
var book_included: bool = false
var verse_included: bool = false

func _ready() -> void:
	translation_check_box.toggled.connect(_on_translation_check_box_toggled)
	book_check_box.toggled.connect(_on_book_check_box_toggled)
	verse_check_box.toggled.connect(_on_verse_check_box_toggled)
	verse_check_box.button_pressed = true
	verse_included = true

func _on_translation_check_box_toggled(toggled_on: bool) -> void:
	translation_included = toggled_on

func _on_book_check_box_toggled(toggled_on: bool) -> void:
	book_included = toggled_on

func _on_verse_check_box_toggled(toggled_on: bool) -> void:
	verse_included = toggled_on
