extends Node

const FILE_SAVE_DIALOG = preload("res://scenes/modules/dialogues/file_save_dialog.tscn")

var file_save_dialog:FileDialog = null

## Signal: file_selected is the file that was selected during last file select dialogue.
signal file_selected(file_path:String)

func _ready() -> void:
	file_save_dialog = FILE_SAVE_DIALOG.instantiate()
	file_save_dialog.file_selected.connect(_on_file_selected)
	add_child(file_save_dialog)
	hide_file_save_dialog()

func show_file_save_dialog() -> void:
	file_save_dialog.show()

func hide_file_save_dialog() -> void:
	file_save_dialog.hide()

func _on_file_selected(selected_file:String) -> void:
	file_selected.emit(selected_file)
	hide_file_save_dialog()
