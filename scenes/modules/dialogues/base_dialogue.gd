extends Control

## This is the standard base dialogue that all dialogues should use.
## It is first instantiated, and then the functional child window
## is added via the set_content method.

class_name BaseDialogue

@export var default_size:Vector2 = Vector2(400, 300)
@export var title_rich_text_label: RichTextLabel 
@export var content_margin_container: MarginContainer 
@export var accept_button: Button
@export var close_button: Button

var hide_close_button:bool = false:
	set(value):
		hide_close_button = value
		if value:
			close_button.hide()
		else:
			close_button.show()

var hide_accept_button:bool = false:
	set(value):
		hide_accept_button = value
		if value:
			accept_button.hide()
		else:
			accept_button.show()

var minimum_size:Vector2 = Vector2(300, 200):
	set(value):
		minimum_size = value
		custom_minimum_size = value

signal closed
signal opened
signal accepted

func _ready() -> void:
	close_button.pressed.connect(_on_close_button_pressed)
	accept_button.pressed.connect(_on_accept_button_pressed)

func set_title(title: String) -> void:
	title_rich_text_label.text = title

func set_content(content:Control) -> void:
	content_margin_container.add_child(content)
	content.setup(self)

func set_minimum_size(_custom_min_size:Vector2)->void:
	minimum_size = _custom_min_size

func _on_accept_button_pressed() -> void:
	accepted.emit()

func _on_close_button_pressed() -> void:
	closed.emit()
	hide()

func open():
	show()
	
func close():
	hide()

## This is called from the child dialogues to close the dialogue
func release() -> void:
	queue_free()
	
func emit_closed() -> void:
	closed.emit()
	
func emit_opened() -> void:
	opened.emit()
	
