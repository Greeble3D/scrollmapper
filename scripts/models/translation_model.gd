extends BaseModel

class_name BibleTranslationModel

var translation_abbr: String
var title: String
var license: String

func _init():
	super._init()
	create_table()

func get_create_table_query() -> String:
	return """
	CREATE TABLE IF NOT EXISTS translations (
		translation_abbr TEXT PRIMARY KEY,
		title TEXT,
		license TEXT
	);
	"""

func save():
	var query = "INSERT INTO translations (translation_abbr, title, license) VALUES (?, ?, ?)
		ON CONFLICT(translation_abbr) DO UPDATE SET title=excluded.title, license=excluded.license;"
	execute_query(query, [translation_abbr, title, license])

func get_all_translations():
	var query = "SELECT * FROM translations;"
	return get_results(query)
