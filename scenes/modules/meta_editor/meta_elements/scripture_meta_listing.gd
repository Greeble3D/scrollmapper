extends MarginContainer

class_name MetaScriptureListing

@export var translation: String
@export var book: String
@export var chapter: int
@export var verse: int
@export var verse_hash: int

@export var scripture_button: Button 
@export var scripture_meta_rich_text_label: RichTextLabel
@export var selected_panel: Panel 

var is_selected:bool = false
signal selected(is_selected:bool, verse_hash:int)

func _ready() -> void:
	scripture_button.pressed.connect(toggle_selection)

## Apply the scripture text to the rich text label
func apply_scripture_text(translation:String, book:String, chapter:int, verse:int, text:String) -> void:
	self.translation = translation
	self.book = book
	self.chapter = chapter
	self.verse = verse
	scripture_meta_rich_text_label.text = "[%s] %s %s:%s - %s" % [translation, book, str(chapter), str(verse), text]

## Toggle the selection of the scripture
func toggle_selection() -> void:
	if is_selected:
		select(false)
	else:
		select(true)

## Select the scripture
func select(_is_selected:bool) -> void:
	is_selected = _is_selected
	toggle_selected_panel()
	selected.emit(_is_selected, verse_hash)
	
## Toggles the background panel. Showing the panel indicates that it is selected.
func toggle_selected_panel():
	if is_selected:
		selected_panel.show()
	else:
		selected_panel.hide()
