extends Control

func _ready():
	hide()

func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("show_cmd"):
			toggle_cmd()

func toggle_cmd():
	if visible:
		hide()
	else:
		show()
