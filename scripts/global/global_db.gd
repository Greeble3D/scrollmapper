extends Node

var db: SQLite = SQLite.new()

func _ready():
	db.path = "res://database.sqlite"
	db.open_db()

func _exit_tree():
	db.close_db()

func get_db() -> SQLite:
	return db
