extends MarginContainer

## This node gets all the unique books from the cross-reference database
## and populates them as a selectable list. Use get_selected_books() to 
## get the selected books in the list.
class_name CrossReferencedBooksSelector

@export var book_item_list: ItemList 
@export var scroll_icons:Array[Texture2D]
@export var selected_count_rich_text_label: RichTextLabel

@export var select_all_button: Button 
@export var select_none_button: Button 

func _ready() -> void:
	book_item_list.clear()
	select_all_button.pressed.connect(_on_select_all_button_pressed)
	select_none_button.pressed.connect(_on_select_none_button_pressed)
	book_item_list.multi_selected.connect(update_books_selected_count)
	var cross_reference_model:CrossReferenceModel = CrossReferenceModel.new("scrollmapper")
	var books:Array = cross_reference_model.get_unique_books()
	for book in books:
		book_item_list.add_item(book, get_scroll_icon(book))		
	book_item_list.deselect_all()
	update_books_selected_count() 
	
func get_scroll_icon(text:String) -> Texture2D:
	var rng = RandomNumberGenerator.new()
	rng.seed = hash(text)
	var idx:int = rng.randi_range(0, scroll_icons.size()-1)
	var texture:Texture2D = scroll_icons[idx]
	return texture

func _on_select_all_button_pressed() -> void:	
	for idx:int in range(0, book_item_list.get_item_count()):
		book_item_list.select(idx, false)
		update_books_selected_count() 
	
func _on_select_none_button_pressed() -> void:
	book_item_list.deselect_all()
	update_books_selected_count() 

func update_books_selected_count(idx:int = 0, selected:bool = false) -> void:
	var selection_size:int = book_item_list.get_selected_items().size()
	selected_count_rich_text_label.text = "Books Selected: " + str(selection_size)
	
func get_selected_books() -> Array[String]:
	var items_selected:PackedInt32Array = book_item_list.get_selected_items()
	var books_selected:Array[String] = []
	for idx:int in items_selected:
		books_selected.append(book_item_list.get_item_text(idx))
	return books_selected
		
