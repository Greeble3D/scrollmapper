extends MarginContainer

const VERSE = preload("res://scenes/modules/verse/verse.tscn")
@onready var scripture_container: VBoxContainer = $ScrollContainer/ScriptureContainer

func _ready() -> void:	
	ScriptureService.verse_cross_references_searched.connect(_on_cross_references_searched)

func _on_cross_references_searched(verses: Array) -> void:
	clear_verses()
	for verse_data in verses:
		setup_verse(verse_data)

func setup_verse(verse_data:Dictionary):
	var verse_instance = VERSE.instantiate()
	verse_instance.initiate_from_json(verse_data, Types.VerseType.CROSS_REFERENCE)
	verse_instance.set_scripture_reference()
	verse_instance.set_scripture_text()
	scripture_container.add_child(verse_instance)


func clear_verses():
	for verse in scripture_container.get_children():
		verse.queue_free()
	
