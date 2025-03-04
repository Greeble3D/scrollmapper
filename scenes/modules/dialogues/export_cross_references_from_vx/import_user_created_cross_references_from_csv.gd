extends Control

class_name ImportUserCreatedCrossReferencesFromCsv

#region standard stuff
## Standard BaseDialogue variable required. 
var base_dialogue:BaseDialogue = null

@export var file_destination_line_edit: LineEdit
@export var file_select_button: Button

@export var title:String = ""
@export var file_path:String = ""
#endregion

#region cross reference importer
var vx_graph:VXGraph
#endregion

## Initiate the dialogue.
func initiate(_vx_graph:VXGraph) -> void:
	vx_graph = _vx_graph

## Setup. This is a required function that takes the BaseDialogue
## Making a new exporter? Just copy/paste this to the new script.
func setup(_base_dialogue:BaseDialogue) -> void:
	base_dialogue = _base_dialogue
	base_dialogue.accepted.connect(_on_accepted)
	base_dialogue.closed.connect(_on_closed)
	base_dialogue.set_title(title)

	# File ops 
	file_select_button.pressed.connect(_on_file_select_button_pressed)
	DialogueManager.file_selected.connect(_on_file_selected)

## Required function for when the Accept button is pushed. 
## Functionality initiated here. 
func _on_accepted() -> void:
	do_import()
	base_dialogue.release()
	vx_graph.lock_graph(false)

## Required function for closing the parent. 
func _on_closed() -> void:
	base_dialogue.release()

func do_import() -> void:
	var importer:ImportCrossReferencesFromCsv = ImportCrossReferencesFromCsv.new(file_path)
	importer.save_csv_to_cross_reference_database()

func _on_file_select_button_pressed() -> void:
	var file_select_dialogue:FileDialog = DialogueManager.show_file_load_dialog()
	file_select_dialogue.filters = ["*.csv"]

func _on_file_selected(selected_file:String) -> void:
	file_path = selected_file
	file_destination_line_edit.text = file_path
