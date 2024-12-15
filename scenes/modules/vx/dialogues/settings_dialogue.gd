extends MarginContainer

## This is the settings dialogue for the graph. 

class_name SettingsDialogue

@export var vx_editor: VXEditor

@export var line_edit_graph_name: LineEdit 
@export var text_edit_graph_description: TextEdit 
@export var button_save: Button

## This triggers when the data has been accepted.
## It only passes the graph name and description because the ID of the grpah is 
## handled elsewhere.
signal data_accepted(graph_name:String, graph_description:String)

func _ready() -> void:
	button_save.pressed.connect(_on_button_save_pressed)
	visibility_changed.connect(initiate)

func initiate() -> void:
	if visible:
		line_edit_graph_name.text = vx_editor.get_current_graph_name()
		text_edit_graph_description.text = vx_editor.get_current_graph_description()

## When the save button is pressed, trigger the save.
func _on_button_save_pressed() -> void:
	var graph_name:String = line_edit_graph_name.text.strip_edges()
	var graph_description:String = text_edit_graph_description.text.strip_edges()
	data_accepted.emit(graph_name, graph_description)
	vx_editor.close_all_dialogues()
