@icon("res://images/icons/editor/Search.svg")
extends HBoxContainer

class_name Explorer

@export var allow_exit_menu:bool = true
var exit_menu:Node = null

var dialogues_anchor:Node = null


func _ready() -> void:
	dialogues_anchor = GameManager.main
	UserInput.escape_key_pressed.connect(exit_to_home)

func exit_to_home() -> void:
	if exit_menu != null:
		return
	const EXIT_TO_HOME = preload("res://scenes/modules/dialogues/export_cross_references_from_vx/exit_to_home.tscn")
	var exit_to_home_window:Node = EXIT_TO_HOME.instantiate()
	exit_menu = exit_to_home_window
	DialogueManager.create_dialogue(exit_to_home_window, dialogues_anchor)
	exit_to_home_window.closed.connect(_on_exit_window_closed)

func _on_exit_window_closed():
	exit_menu = null
