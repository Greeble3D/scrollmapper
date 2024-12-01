extends MarginContainer

class_name Explore

const VERSE: PackedScene = preload("res://scenes/modules/verse/verse.tscn")

@export_category("States and Conditions")

@export var is_vx_results: bool = false
@export var close_on_click: bool = false

@export var scripture_container: VBoxContainer

signal search_results_received
signal option_pressed

func _ready() -> void:
	ScriptureService.verses_searched.connect(_on_verses_searched)

func _on_verses_searched(verses: Array) -> void:
	clear_verses()
	search_results_received.emit()
	for verse_data in verses:
		setup_verse(verse_data)

func setup_verse(verse_data: Dictionary) -> void:
	var verse_instance: Verse = VERSE.instantiate()
	var verse_type: Types.VerseType = Types.VerseType.BASIC
	if is_vx_results:
		verse_type = Types.VerseType.VX_LISTING
	verse_instance.initiate_from_json(verse_data, verse_type)
	verse_instance.set_scripture_reference()
	verse_instance.set_scripture_text()
	verse_instance.button_pressed.connect(emit_option_pressed)
	scripture_container.add_child(verse_instance)


func clear_verses() -> void:
	for verse in scripture_container.get_children():
		verse.queue_free()

func emit_option_pressed()->void:
	option_pressed.emit()
