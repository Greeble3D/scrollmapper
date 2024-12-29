extends Area3D

## This is a trigger for level launching. Simply drag the node onto an Area3D 
## object for it to work. See the full instructions in "res://scripts/misc/home.gd"
class_name Launcher

var is_mouse_over:bool = false:
	set(value):
		is_mouse_over = value
		hovered.emit(is_mouse_over)

## Will emit if the mouse enters. 
signal hovered(mouse_over:bool)

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	UserInput.clicked.connect(do_launch)
	
func _on_mouse_entered() -> void:
	is_mouse_over = true
	
func _on_mouse_exited() -> void:
	is_mouse_over = false

## Launches the appropriate level according to the name in the launcher meta. 
func do_launch() -> void:
	var level_name:String = get_meta("launcher", "NONE")
	if level_name == "NONE":
		return
	if not is_mouse_over:
		return
	Command.instance.execute("load_level -l %s"%level_name)
