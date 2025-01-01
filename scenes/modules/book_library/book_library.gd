extends Control

class_name BookLibrary

const BOOK_LISTING = preload("res://scenes/modules/book_library/grid_elements/book_listing.tscn")

## The main book list container. 
@export var book_list: VBoxContainer

## Button to queue the update from a list online at github 
## https://raw.githubusercontent.com/scrollmapper/book_list/refs/heads/main/book_list.json
@export var update_list_button: Button

## Syncronizes the database to chosen llist options.
@export var syncronize_button: Button 

## Close the window. 
@export var done_button: Button

var book_list_items:Array[BookListing] = []

func _ready() -> void:
	update_list_button.pressed.connect(_on_update_list_button_pressed)
	syncronize_button.pressed.connect(_on_syncronize_button_pressed)
	done_button.pressed.connect(_on_done_button_pressed)
	update_lists()


func update_lists():
	for child in book_list.get_children():
		child.queue_free()	
	var source_list:SourceReferenceList = LibraryManager.source_reference_list
	for biblical_source:SourceReference in source_list.get_biblical_sources():
		add_listing(biblical_source)

func add_listing(source_reference:SourceReference) -> void:
	var new_book_listing:BookListing = BOOK_LISTING.instantiate()
	new_book_listing.book = source_reference.book
	new_book_listing.title = source_reference.title
	new_book_listing.language = source_reference.language
	new_book_listing.content_type = source_reference.content_type
	book_list.add_child(new_book_listing)

func _on_update_list_button_pressed():
	LibraryManager.update_source_list()

func _on_syncronize_button_pressed():
	print("SYRNCONIZE")
	
func _on_done_button_pressed():
	GameManager.load_level("HOME")
