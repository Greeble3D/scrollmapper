extends Node3D

## This is the main launcher scene, the "Home" scene. It is meant to provide a 
## bit of engagement and moood for scripture analysis. 
##
## USE:
##
## To create a launcher, simply 
##    1: Add an Area3D node with the necessary collision.
##    setup, such as a BoxShape 3d. 
##    2: Add it to the group "launchers" (spelled exactly).
##    3: Add a meta data entry to it (string) with the key "launcher".
##    4: The launcher value should be the name of the level that you wish to lauch.
##    5: Add a Launcher script to it. Found in "res://scripts/misc/launcher.gd"
##
##    For example, the VXGraph Area3D node has a meta data entry assigned to it
##    as such: key launcher, value: vx_graph. This launches the VXGraph system.
## 
## This system was created so that other scenes could be added easily, replacing 
## the default, allowing modability and such. 
class_name Home

@export var camera_3d:Camera3D 
@export var launchers:Array[Area3D]

signal launcher_focused(name:String)

func _ready() -> void:
	setup_launchers()


## Gets the launchers and adds them to system. 
func setup_launchers() -> void:
	var launcher_nodes:Array = get_tree().get_nodes_in_group("launchers")
	for launcher in launcher_nodes:
		if launcher is Area3D && launcher.has_meta("launcher"):
			launchers.append(launcher)
			launcher.current_focused_launcher_changed.connect(emit_launcher_focused)

func emit_launcher_focused(name:String) -> void:
	launcher_focused.emit(name)
