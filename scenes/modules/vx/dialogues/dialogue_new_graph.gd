extends MarginContainer

@export var save_current_graph:CheckBox
@export var create_new_graph:Button

signal create_new_graph_pressed(save:bool)

func _ready():
	create_new_graph.pressed.connect(_on_create_new_graph_pressed)
	
func _on_create_new_graph_pressed():
	create_new_graph_pressed.emit(save_current_graph.button_pressed)
