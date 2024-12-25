extends Node

const BASE_DIALOGUE = preload("res://scenes/modules/dialogues/base_dialogue.tscn")

const FILE_SAVE_DIALOG = preload("res://scenes/modules/dialogues/file_save_dialog.tscn")

var file_save_dialog:FileDialog = null

## Signal: file_selected is the file that was selected during last file select dialogue.
signal file_selected(file_path:String)

func _ready() -> void:
	# Set up the file save dialogue.
	file_save_dialog = FILE_SAVE_DIALOG.instantiate()
	file_save_dialog.file_selected.connect(_on_file_selected)
	add_child(file_save_dialog)
	hide_file_save_dialog()

## Will show the file save dialogue.
func show_file_save_dialog() -> FileDialog:
	file_save_dialog.show()
	return file_save_dialog

## Will hide the file save dialogue.
func hide_file_save_dialog() -> void:
	file_save_dialog.hide()

func _on_file_selected(selected_file:String) -> void:
	file_selected.emit(selected_file)
	hide_file_save_dialog()


## Function: create_dialogue
## Description: Creates a dialogue and adds it to the specified anchor node.
## This is a generic function that can be used to create any dialogue.
## 
## Parameters:
## - content (Control): The content of the dialogue. This must be a Control node.
## - anchor_to (Node): The node to which the content will be added as a child.
# 
## Usage:
## Call this function with the dialogue content and the node you want to anchor it to.
## Example:
## create_dialogue(dialogue_content, anchor_node)
func create_dialogue(content:Control, anchor_to:Node) -> Control:
	var bd:BaseDialogue = BASE_DIALOGUE.instantiate()
	bd.set_content(content)
	content.base_dialogue = bd
	anchor_to.add_child(bd)
	return bd
