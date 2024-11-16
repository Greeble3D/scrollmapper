extends BaseModel

class_name BibleTranslationModel

var id: int  # Added id variable
var translation_abbr: String
var title: String
var license: String

func _init():
	super._init()
	create_table()

func get_create_table_query() -> String:
	return """
	CREATE TABLE IF NOT EXISTS translations (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		translation_abbr TEXT UNIQUE,
		title TEXT,
		license TEXT
	);
	"""

func save():
	# Check if translation already exists
	var query = "SELECT id FROM translations WHERE translation_abbr = ?;"
	var result = get_results(query, [translation_abbr])
	
	if result.size() > 0:
		# Update existing translation
		id = result[0]["id"]
		var update_query = "UPDATE translations SET title = ?, license = ? WHERE id = ?;"
		execute_query(update_query, [title, license, id])
	else:
		# Insert new translation
		var insert_query = "INSERT INTO translations (translation_abbr, title, license) VALUES (?, ?, ?);"
		execute_query(insert_query, [translation_abbr, title, license])
		
		# Retrieve the last inserted ID
		result = get_results("SELECT last_insert_rowid() as id;")
		if result.size() > 0:
			id = result[0]["id"]

func get_all_translations() -> Array:
	var query = "SELECT * FROM translations;"
	return get_results(query)

# Method to get a specific translation by abbreviation
func get_translation(translation_abbr: String) -> Dictionary:
	var query = "SELECT * FROM translations WHERE translation_abbr = ?;"
	var result = get_results(query, [translation_abbr])
	if result.size() > 0:
		return result[0]
	return {}

# Method to delete a translation
func delete():
	if id != null:
		var query = "DELETE FROM translations WHERE id = ?;"
		execute_query(query, [id])
	else:
		print("Translation ID is not set, cannot delete the entry.")
