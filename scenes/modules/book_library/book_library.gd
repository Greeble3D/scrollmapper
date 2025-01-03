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

var listings:Dictionary = {}

var book_list_items:Array[BookListing] = []

var is_processing_book:bool = false
signal book_process_complete

func _ready() -> void:
	update_list_button.pressed.connect(_on_update_list_button_pressed)
	syncronize_button.pressed.connect(_on_syncronize_button_pressed)
	done_button.pressed.connect(_on_done_button_pressed)
	update_lists()

func update_lists():
	for child in book_list.get_children():
		child.queue_free()	
	listings.clear()
	var source_list:SourceReferenceList = LibraryManager.source_reference_list
	for biblical_source:SourceReference in source_list.get_extrabiblical_sources():
		add_listing(biblical_source)
	for biblical_source:SourceReference in source_list.get_biblical_sources():
		add_listing(biblical_source)

func add_listing(source_reference:SourceReference) -> void:
	var new_book_listing:BookListing = BOOK_LISTING.instantiate()
	new_book_listing.book = source_reference.book
	new_book_listing.title = source_reference.title
	new_book_listing.language = source_reference.language
	new_book_listing.content_type = source_reference.content_type
	new_book_listing.set_current_status()
	book_list.add_child(new_book_listing)
	listings[new_book_listing.book] = new_book_listing

func _on_update_list_button_pressed():
	LibraryManager.update_source_list()

func _on_syncronize_button_pressed():
	syncronize_book_selections()
	
func _on_done_button_pressed():
	GameManager.load_level("HOME")

func syncronize_book_selections():
	await get_tree().process_frame
	for book_listing in listings.keys():

		if is_processing_book:
			await book_process_complete		
			
		book_listing = listings[book_listing]
		if not book_listing.is_installed and book_listing.is_selected:
			print("Installing " + book_listing.book)
			do_install_book_process(book_listing)
		elif book_listing.is_installed and !book_listing.is_selected:
			print("Uninstalling " + book_listing.book)
			do_uninstall_book_process(book_listing)
	update_lists()
	
func do_install_book_process(book_listing:BookListing):
	is_processing_book = true
	var install_book:InstallBook = InstallBook.new(book_listing.book)
	if !install_book.is_book_file_available():
		ResourceDownloader.instance.retrieve_book(book_listing.book)
		await ResourceDownloader.instance.download_process_complete
		
	install_book.install()
	

	is_processing_book = false
	book_process_complete.emit()

func do_uninstall_book_process(book_listing:BookListing):
	is_processing_book = true
	if book_listing.content_type == "extrabiblical":
		ScriptureService.uninstall_book("scrollmapper", book_listing.title)
	if book_listing.content_type == "bible":
		ScriptureService.uninstall_translation(book_listing.book)

	is_processing_book = false
	book_process_complete.emit()
