extends Node

var db: SQLite = SQLite.new()

func _ready():
	var data_manager = DataManager.new()
	data_manager.create_initial_directories()
	db.path = data_manager.get_scrollmapper_db_dir().path_join("database.sqlite")
	db.open_db()

func _exit_tree():
	db.close_db()

func get_db() -> SQLite:
	return db
