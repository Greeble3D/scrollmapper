extends Control

#region standard stuff
## Standard BaseDialogue variable required. 
var base_dialogue:BaseDialogue = null

@export var file_destination_line_edit: LineEdit
@export var file_select_button: Button
@export var cross_referenced_books_selector: CrossReferencedBooksSelector
@export var csv_format_option_button: OptionButton 
@export var user_generated_check_box: CheckBox

@export var title:String = ""
@export var file_path:String = ""
#endregion


## Setup. This is a required function that takes the BaseDialogue
## Making a new exporter? Just copy/paste this to the new script.
func setup(_base_dialogue:BaseDialogue) -> void:
	base_dialogue = _base_dialogue
	base_dialogue.accepted.connect(_on_accepted)
	base_dialogue.closed.connect(_on_closed)
	base_dialogue.set_title(title)
	base_dialogue.set_minimum_size(Vector2(600, 400))

	# File ops 
	file_select_button.pressed.connect(_on_file_select_button_pressed)
	DialogueManager.file_selected.connect(_on_file_selected)
	
## Required function for when the Accept button is pushed. 
## Functionality initiated here. 
func _on_accepted() -> void:
	do_export()
	base_dialogue.release()

## Required function for closing the parent. 
func _on_closed() -> void:
	base_dialogue.release()

func do_export() -> void:	
	var format:String = "Scrollmapper"
	if csv_format_option_button.selected == 1:
		format = "OpenBible"
	var selected_books:Array[String] = cross_referenced_books_selector.get_selected_books()
	var exporter:ExporterCrossReferencesToCSV = ExporterCrossReferencesToCSV.new(file_path, selected_books, format, user_generated_check_box.button_pressed)
	exporter.export()
	
func _on_file_select_button_pressed() -> void:
	var file_select_dialogue:FileDialog = DialogueManager.show_file_save_dialog(["*.csv;CSV Files"])
	file_select_dialogue
	file_select_dialogue.current_file = "cross-references.csv"

func _on_file_selected(selected_file:String) -> void:
	file_path = selected_file
	file_destination_line_edit.text = file_path
