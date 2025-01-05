extends MarginContainer

class_name ReadingTitle

var title:String = "":
	set(value):
		title = value
		set_rich_text_label_title(value)

@export var title_rich_text_label: RichTextLabel

func set_rich_text_label_title(_title:String) -> void:
	title_rich_text_label.text = _title
