extends SpotLight3D

class_name InteractionLight

@export var launcher:Launcher = null

func _ready() -> void:
	launcher.hovered.connect(set_light_hovered)
	turn_off()

func set_light_hovered(is_mouse_over:bool) -> void:
	if is_mouse_over:
		show()
	else:
		hide()

func turn_on() -> void:
	show()
	
func turn_off() -> void:
	hide()
