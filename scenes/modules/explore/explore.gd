extends MarginContainer

const VERSE = preload("res://scenes/modules/verse/verse.tscn")

@export var scripture_container: VBoxContainer

func _ready() -> void:
	ScriptureService.verses_searched.connect(_on_verses_searched)

func _on_verses_searched(verses: Array) -> void:
	clear_verses()
	for verse_data in verses:
		setup_verse(verse_data)

func setup_verse(verse_data:Dictionary):
	var verse_instance = VERSE.instantiate()
	verse_instance.initiate_from_json(verse_data)
	verse_instance.set_scripture_reference()
	verse_instance.set_scripture_text()
	scripture_container.add_child(verse_instance)


func clear_verses():
	for verse in scripture_container.get_children():
		verse.queue_free()
	
