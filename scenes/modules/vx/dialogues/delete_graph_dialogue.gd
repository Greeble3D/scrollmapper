extends MarginContainer

class_name DeleteGraphDialogue

@export var vx_editor: VXEditor

@export var delete_button: Button
@export var cancel_button: Button 

signal delete_graph

func _ready() -> void:
	delete_button.pressed.connect(_on_delete_button_pressed)
	cancel_button.pressed.connect(_on_cancel_button_pressed)

func _on_delete_button_pressed():
	delete_graph.emit()

func _on_cancel_button_pressed():
	vx_editor.close_all_dialogues()
