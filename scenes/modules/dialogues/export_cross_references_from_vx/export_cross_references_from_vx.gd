extends Control

#region standard stuff
## Standard BaseDialogue variable required. 
var base_dialogue:BaseDialogue = null

@export var title:String = ""
#endregion

#region cross reference exporter
var vx_graph:VXGraph
#endregion

## Initiate the dialogue.
func inititate(_vx_graph:VXGraph) -> void:
	vx_graph = _vx_graph

## Setup. This is a required function that takes the BaseDialogue
## Making a new exporter? Just copy/paste this to the new script.
func setup(_base_dialogue:BaseDialogue) -> void:
	base_dialogue = _base_dialogue
	base_dialogue.accepted.connect(_on_accepted)
	base_dialogue.closed.connect(_on_closed)
	base_dialogue.set_title(title)

## Required function for when the Accept button is pushed. 
## Functionality initiated here. 
func _on_accepted() -> void:
	do_export()
	base_dialogue.release()

## Required function for closing the parent. 
func _on_closed() -> void:
	base_dialogue.release()

func do_export() -> void:
	var exporter:ExporterVXNodeToCrossReference = ExporterVXNodeToCrossReference.new(vx_graph)
	exporter.export()
