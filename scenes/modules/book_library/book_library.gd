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

func _on_update_list_button_pressed():
	"UPDATE LIST"

func _on_syncronize_button_pressed():
	"SYRNCONIZE"

func _on_done_button_pressed():
	GameManager.load_level("HOME")
