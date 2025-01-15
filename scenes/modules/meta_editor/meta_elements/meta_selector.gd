extends MarginContainer

class_name MarginSelector

@export var verse_meta_rich_text_label: RichTextLabel 
@export var book_meta_rich_text_label: RichTextLabel
@export var translation_meta_rich_text_label: RichTextLabel 

@export var verse_meta_key_v_box_container: VBoxContainer
@export var book_meta_key_v_box_container: VBoxContainer
@export var translation_meta_key_v_box_container: VBoxContainer 

var verse_meta_check_box_options:Array[CheckBox] = []
var book_meta_check_box_options:Array[CheckBox] = []
var translation_meta_check_box_options:Array[CheckBox] = []

## Determines if the verse meta will be included in the export
var include_verse_meta:bool = true:
	set(value):
		include_verse_meta = value
		toggle_verse_meta_container()		

## Determines if the book meta will be included in the export
var include_book_meta:bool = true:
	set(value):
		include_book_meta = value
		toggle_book_meta_container()

## Determines if the translation meta will be included in the export
var include_translation_meta:bool = true:
	set(value):
		include_translation_meta = value
		toggle_translation_meta_container()

func _ready() -> void:
	var unique_verse_meta:Array = ScriptureService.get_unique_verse_meta()
	var unique_book_meta:Array =  ScriptureService.get_unique_book_meta()
	var unique_translation_meta:Array = ScriptureService.get_unique_translation_meta()
	
	clear_all_containers()
	
	for i in range(unique_verse_meta.size()):
		create_meta_check_box_option("verse", unique_verse_meta[i]["key"], i)
	for i in range(unique_book_meta.size()):
		create_meta_check_box_option("book", unique_book_meta[i]["key"], i)
	for i in range(unique_translation_meta.size()):
		create_meta_check_box_option("translation", unique_translation_meta[i]["key"], i)

## Returns the selected verse meta keys
func get_selected_verse_meta_keys() -> Array[String]:
	var keys:Array[String] = []
	for check_box in verse_meta_check_box_options:
		if check_box.button_pressed:
			keys.append(check_box.text)
	return keys

## Returns the selected book meta keys
func get_selected_book_meta_keys() -> Array[String]:
	var keys:Array[String] = []
	for check_box in book_meta_check_box_options:
		if check_box.button_pressed:
			keys.append(check_box.text)
	return keys

## 	Returns the selected translation meta keys
func get_selected_translation_meta_keys() -> Array[String]:
	var keys:Array[String] = []
	for check_box in translation_meta_check_box_options:
		if check_box.button_pressed:
			keys.append(check_box.text)
	return keys

## Creates a check box option for the verse meta
func create_meta_check_box_option(checkbox_type:String, key:String, id:int) -> CheckBox:
	var check_box:CheckBox = CheckBox.new()
	check_box.text = key
	check_box.set_meta("id", id)
	match checkbox_type.to_lower():
		"verse":
			verse_meta_key_v_box_container.add_child(check_box)
			verse_meta_check_box_options.append(check_box)
		"book":
			book_meta_key_v_box_container.add_child(check_box)
			book_meta_check_box_options.append(check_box)
		"translation":
			translation_meta_key_v_box_container.add_child(check_box)
			translation_meta_check_box_options.append(check_box)
	return check_box

## Toggles the visibility of the verse meta container
func toggle_verse_meta_container() -> void:
	if include_book_meta == true:
		verse_meta_key_v_box_container.show()
	else:
		verse_meta_key_v_box_container.hide()

## Toggles the visibility of the book meta container
func toggle_book_meta_container() -> void:
	if include_book_meta == true:
		book_meta_key_v_box_container.show()
	else:
		book_meta_key_v_box_container.hide()

## Toggles the visibility of the translation meta container
func toggle_translation_meta_container() -> void:
	if include_translation_meta == true:
		translation_meta_key_v_box_container.show()
	else:
		translation_meta_key_v_box_container.hide()

func clear_all_containers() -> void:
	clear_verse_meta_key_v_box_container()
	clear_book_meta_key_v_box_container()
	clear_translation_meta_key_v_box_container()

## Clears the verse meta key v box container
func clear_verse_meta_key_v_box_container() -> void:
	for child in verse_meta_key_v_box_container.get_children():
		child.queue_free()
	verse_meta_check_box_options.clear()

## Clears the book meta key v box container
func clear_book_meta_key_v_box_container() -> void:
	for child in book_meta_key_v_box_container.get_children():
		child.queue_free()
	book_meta_check_box_options.clear()

## Clears the translation meta key v box container
func clear_translation_meta_key_v_box_container() -> void:
	for child in translation_meta_key_v_box_container.get_children():
		child.queue_free()
	translation_meta_check_box_options.clear()
