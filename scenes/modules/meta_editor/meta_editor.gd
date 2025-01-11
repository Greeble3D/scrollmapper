extends Control

class_name MetaEditor

#region instantiatable objects
const SCRIPTURE_META_LISTING = preload("res://scenes/modules/meta_editor/meta_elements/scripture_meta_listing.tscn")
const META_KEY_BROWSER_OPTION = preload("res://scenes/modules/meta_editor/meta_elements/meta_key_browser_option.tscn")
#endregion 

@export_category("Search Variables")
#region search mode
@export var search_mode_check_button: CheckButton 
@export var scripture_search_v_box_container: VBoxContainer 
@export var meta_search_v_box_container: VBoxContainer 
#endregion 

#region listings
@export var meta_scripture_button_v_box_container: VBoxContainer 
#endregion 

#region selections 
var selected_listings: Array[MetaScriptureListing] = []
@export var select_all_button: Button
@export var select_none_button: Button 
@export var selected_listings_rich_text_label: RichTextLabel 
signal selections_updated
#endregion 

@export_category("Meta Search Variables")
#region meta search
# Meta Search 
@export var meta_search_line_edit: LineEdit 
@export var search_meta_fliter: MetaFilter 
@export var browse_meta_keys_button: Button 
@export var search_by_meta_button: Button 
# Meta Browsing Panel
@export var meta_browse_panel: Panel
@export var translation_meta_v_box_container: VBoxContainer
@export var book_meta_v_box_container: VBoxContainer
@export var verse_meta_v_box_container: VBoxContainer 
@export var close_meta_browse_button: Button 
#endregion  

@export_category("Meta Assignment Variables")
#region meta assignment 
@export var meta_fliter: MetaFilter
@export var meta_key_line_edit: LineEdit
@export var meta_value_text_edit: TextEdit
@export var add_meta_button: Button 
@export var delete_meta_button: Button
#endregion 




func _ready() -> void:
	clear_listings()
	meta_browse_panel.hide()
	# Search Signals and ops
	_update_selected_listings_label()
	selections_updated.connect(_update_selected_listings_label)
	select_all_button.pressed.connect(_on_select_all_button_pressed)
	select_none_button.pressed.connect(_on_select_none_button_pressed)
	scripture_search_v_box_container.show()
	meta_search_v_box_container.hide()
	search_mode_check_button.toggled.connect(_on_search_mode_check_button_toggled)
	ScriptureService.verses_searched.connect(_on_verses_searched)
	# Meta Search Signals and ops
	browse_meta_keys_button.pressed.connect(_on_browse_meta_keys_button_pressed)
	search_by_meta_button.pressed.connect(_on_search_by_meta_button_pressed)
	close_meta_browse_button.pressed.connect(_on_close_meta_browse_button_pressed)
	# Meta Assignment Signals and ops
	add_meta_button.pressed.connect(_on_add_meta_button_pressed)
	delete_meta_button.pressed.connect(_on_delete_meta_button_pressed)
	meta_key_line_edit.text_changed.connect(_on_meta_key_line_edit_text_changed)

#region search and select functionality (left panel)
func _on_search_mode_check_button_toggled(state:bool) -> void:
	if state == true:
		scripture_search_v_box_container.show()
		meta_search_v_box_container.hide()
	else:
		scripture_search_v_box_container.hide()
		meta_search_v_box_container.show()

func create_meta_listing(translation:String, book:String, chapter:int, verse:int, text:String) -> void:
	var meta_listing:MetaScriptureListing = SCRIPTURE_META_LISTING.instantiate()
	meta_listing.apply_scripture_text(translation, book, chapter, verse, text)
	meta_scripture_button_v_box_container.add_child(meta_listing)
	meta_listing.select(false)
	meta_listing.selected.connect(_on_meta_listing_selected)

func _on_verses_searched(search_results:Array) -> void:
	clear_listings()
	for search_result in search_results:
		create_meta_listing(
			search_result["translation"]["translation_abbr"], 
			search_result["book"]["book_name"], 
			search_result["chapter"], 
			search_result["verse"], 
			search_result["text"]
		)

func update_selected_listings() -> void:
	selected_listings.clear()
	for child in meta_scripture_button_v_box_container.get_children():
		var meta_listing:MetaScriptureListing = child
		if meta_listing.is_selected:
			selected_listings.append(meta_listing)

func _on_meta_listing_selected(is_selected:bool) -> void:
	update_selected_listings()
	selections_updated.emit()

func clear_listings() -> void:
	for child in meta_scripture_button_v_box_container.get_children():
		var meta_listing:MetaScriptureListing = child
		meta_listing.queue_free()
	selected_listings.clear()

func _on_select_all_button_pressed():
	for child in meta_scripture_button_v_box_container.get_children():
		var meta_listing:MetaScriptureListing = child
		meta_listing.select(true)
	selections_updated.emit()

func _on_select_none_button_pressed():
	for child in meta_scripture_button_v_box_container.get_children():
		var meta_listing:MetaScriptureListing = child
		meta_listing.select(false)
	selections_updated.emit()

func _update_selected_listings_label() -> void:
	var selected_text:String = "%s selected" % selected_listings.size()
	selected_listings_rich_text_label.text = selected_text
#endregion 

#region meta search functionality (left panel)
func _on_browse_meta_keys_button_pressed():
	meta_browse_panel.show()
	populate_meta_keys_to_meta_browse_panel()

func _on_search_by_meta_button_pressed():
	print("SEARCH META")
	
func _on_close_meta_browse_button_pressed():
	meta_browse_panel.hide()

## Populate the meta keys to the meta browse panel in the three main 
## containers: book_meta_v_box_container, translation_meta_v_box_container, and verse_meta_v_box_container
func populate_meta_keys_to_meta_browse_panel():
	for child in book_meta_v_box_container.get_children():
		child.queue_free()
	for child in translation_meta_v_box_container.get_children():
		child.queue_free()
	for child in verse_meta_v_box_container.get_children():
		child.queue_free()

	var unique_book_meta = ScriptureService.get_unique_book_meta()
	print(unique_book_meta)
	for meta in unique_book_meta:
		print(meta)
		var meta_option = META_KEY_BROWSER_OPTION.instantiate()
		meta_option.meta_key = meta["key"]
		meta_option.is_book_meta = true
		book_meta_v_box_container.add_child(meta_option)
		meta_option.meta_key_chosen.connect(_on_meta_key_chosen)
		meta_option.delete_meta_key_chosen.connect(_on_delete_meta_key_chosen)
	
	var unique_translation_meta = ScriptureService.get_unique_translation_meta()
	for meta in unique_translation_meta:
		var meta_option = META_KEY_BROWSER_OPTION.instantiate()
		meta_option.is_translation_meta = true
		meta_option.meta_key = meta["key"]
		translation_meta_v_box_container.add_child(meta_option)
		meta_option.meta_key_chosen.connect(_on_meta_key_chosen)
		meta_option.delete_meta_key_chosen.connect(_on_delete_meta_key_chosen)

	var unique_verse_meta = ScriptureService.get_unique_verse_meta()
	for meta in unique_verse_meta:
		var meta_option = META_KEY_BROWSER_OPTION.instantiate()
		meta_option.is_verse_meta = true
		meta_option.meta_key = meta["key"]
		verse_meta_v_box_container.add_child(meta_option)
		meta_option.meta_key_chosen.connect(_on_meta_key_chosen)
		meta_option.delete_meta_key_chosen.connect(_on_delete_meta_key_chosen)

func _on_delete_meta_key_chosen(meta_key:String, meta_type:String) -> void:
	print("DELETE META KEY CHOSEN: %s" % meta_key)
	print("META TYPE: %s" % meta_type)
	meta_browse_panel.hide()

func _on_meta_key_chosen(meta_key:String, meta_type:String) -> void:
	search_meta_fliter.book_check_box.button_pressed = false
	search_meta_fliter.translation_check_box.button_pressed = false
	search_meta_fliter.verse_check_box.button_pressed = false
	match meta_type:
		"book":
			search_meta_fliter.book_check_box.button_pressed = true
		"translation":
			search_meta_fliter.translation_check_box.button_pressed = true
		"verse":
			search_meta_fliter.verse_check_box.button_pressed = true
		_:
			print("META TYPE NOT FOUND")
	meta_search_line_edit.text = meta_key
	meta_browse_panel.hide()

#endregion 

#region meta assignment functionality (right panel)

func _on_add_meta_button_pressed():
	if meta_key_line_edit.text.strip_edges().is_empty():
		return
	assign_meta()

func _on_delete_meta_button_pressed():
	if meta_key_line_edit.text.strip_edges().is_empty():
		return
	delete_meta()

func assign_meta() -> void:
	for selected_listing in selected_listings:
		var verse_hash:int = ScriptureService.get_verse_hash(
			selected_listing.book, 
			selected_listing.chapter, 
			selected_listing.verse
		)
		var book_hash:int = ScriptureService.get_book_hash(selected_listing.book)
		var translation_hash:int = ScriptureService.get_translation_hash(selected_listing.translation)

		if meta_fliter.translation_included:
			ScriptureService.set_translation_meta(translation_hash, meta_key_line_edit.text, meta_value_text_edit.text)
		if meta_fliter.book_included:
			ScriptureService.set_book_meta(book_hash, meta_key_line_edit.text, meta_value_text_edit.text)
		if meta_fliter.verse_included:
			ScriptureService.set_verse_meta(verse_hash, meta_key_line_edit.text, meta_value_text_edit.text)


func delete_meta() -> void:
	for selected_listing in selected_listings:
		var verse_hash:int = ScriptureService.get_verse_hash(
			selected_listing.book, 
			selected_listing.chapter, 
			selected_listing.verse
		)
		var book_hash:int = ScriptureService.get_book_hash(selected_listing.book)
		var translation_hash:int = ScriptureService.get_translation_hash(selected_listing.translation)

		if meta_fliter.translation_included:
			ScriptureService.delete_translation_meta(translation_hash, meta_key_line_edit.text)
		if meta_fliter.book_included:
			ScriptureService.delete_book_meta(book_hash, meta_key_line_edit.text)
		if meta_fliter.verse_included:
			ScriptureService.delete_verse_meta(verse_hash, meta_key_line_edit.text)

func _on_meta_key_line_edit_text_changed(text:String) -> void:
	var meta_key:String = sluggify_meta_key(text)
	meta_key_line_edit.text = meta_key
	meta_key_line_edit.caret_column = meta_key.length()


func sluggify_meta_key(text:String) -> String:
	var meta_key:String = GlobalFunctions.slugify(text)
	return meta_key

#endregion 
