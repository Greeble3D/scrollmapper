@icon("res://images/icons/editor/Terminal.svg")
extends Control

class_name CMDContainer
@export var canvas_layer: CanvasLayer 

func _ready():
	hide_cmd()

func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("show_cmd"):
			toggle_cmd()

func toggle_cmd():
	if visible:
		show_cmd()
	else:
		hide_cmd()

func show_cmd():
	canvas_layer.visible = true
	hide()
	
	
func hide_cmd():
	show()
	canvas_layer.visible = false
