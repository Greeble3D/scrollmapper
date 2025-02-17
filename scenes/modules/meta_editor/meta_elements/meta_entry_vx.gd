extends MarginContainer

## This is a VX (Cross-verse) specific meta entry, used in the cross-verse UI.
## It is more compact and specialized to that interface.
class_name MetaEntryVX

@export var meta_key_rich_text_label: RichTextLabel 
@export var meta_delete_button: Button 

#region Mirrored from VerseMetaModel
var id: int = 0
var verse_hash: int = 0
var key: String = ""
var value: String = ""
#endregion 

func _ready() -> void:
	meta_delete_button.pressed.connect(_on_meta_delete_button_pressed)
	
func initiate(verse_meta:Dictionary) -> void:
	id = verse_meta["id"]
	verse_hash = verse_meta["verse_hash"]
	key = verse_meta["key"]
	value = verse_meta["value"]
	meta_key_rich_text_label.text = "Meta Key: "+str(key)
	meta_key_rich_text_label.tooltip_text = "Meta Value: "+str(value)

func delete() -> void:
	ScriptureService.delete_verse_meta_by_id(id)
	queue_free()

func _on_meta_delete_button_pressed() -> void:
	delete()
