extends Node


#region Level Scenes

const EXPLORE = preload("res://scenes/modules/explore/explorer.tscn")
const VX_GRAPH = preload("res://scenes/modules/vx/vx_graph.tscn")
const HOME = preload("res://scenes/home/home.tscn")
const BOOK_LIBRARY = preload("res://scenes/modules/book_library/book_library.tscn")

var current_level:Node = null

#endregion 

#region Main Scene Tree

@onready var main: Node3D = $"../Main"
@onready var ui: Control = $"../Main/UI"
@onready var modules: Control = $"../Main/UI/Modules"

#endregion 

signal level_ready(level:Node)

func _ready() -> void:
	load_level("HOME")

## This is called from a level when it is loaded. 
## The main purpose is for unloading later. 
func register_level(level:Node) -> void:
	current_level = level
	level_ready.emit(level)

## Main level loader. Should be called from command.
## We call this from command for two reasons:
##    1: Testing
##    2: Mod-ability. 
func load_level(level:String, custom:String = "") -> void:
	if current_level != null:
		current_level.queue_free()
	var level_type:Types.LevelType = Types.LevelType.get(level.to_upper(), "HOME")
	match level_type:
		Types.LevelType.HOME:
			var home_level:Node3D = HOME.instantiate()
			main.add_child(home_level)
			register_level(home_level)
		Types.LevelType.VX_GRAPH:
			var vx_graph_level:VXGraph = VX_GRAPH.instantiate()
			modules.add_child(vx_graph_level)
			register_level(vx_graph_level)
		Types.LevelType.EXPLORER:
			var explorer_level:HBoxContainer = EXPLORE.instantiate() 
			modules.add_child(explorer_level)
			register_level(explorer_level)
		Types.LevelType.BOOK_LIBRARY:
			var book_library_level:BookLibrary = BOOK_LIBRARY.instantiate()
			modules.add_child(book_library_level)
			register_level(book_library_level)
		_:
			var home_level:Node3D = HOME.instantiate()
			main.add_child(home_level)
