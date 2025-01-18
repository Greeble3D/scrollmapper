extends Node

## This is the database reference for when running in editor mode. 
## It is initiated by res://addons/cmd/cmd.gd
class_name EditorDB

static var db:SQLite 

static func initiate() -> void:
	db = SQLite.new()
	var data_manager = DataManager.new()
	data_manager.create_initial_directories()
	db.path = data_manager.get_scrollmapper_db_dir().path_join("database.sqlite")
	db.open_db()
