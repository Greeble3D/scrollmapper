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
		self.id = result[0]["id"]
		self.translation_abbr = result[0]["translation_abbr"]
		self.title = result[0]["title"]
		self.license = result[0]["license"]
		return result[0]
	return {}

# Method to delete a translation
func delete():
	if id != null:
		var query = "DELETE FROM translations WHERE id = ?;"
		execute_query(query, [id])
	else:
		print("Translation ID is not set, cannot delete the entry.")

func is_translation_installed(_translation_name: String) -> bool:
	var query = "SELECT COUNT(*) as count FROM translations WHERE translation_abbr = ?;"
	var result = get_results(query, [_translation_name])
	
	if result.size() > 0 and result[0]["count"] > 0:
		return true
	return false

func uninstall_book(book_name: String):
	var book_model = BookModel.new(translation_abbr)
	book_model.get_book_by_name(book_name)
	if book_model.id != 0:
		book_model.delete()
		print("Book '%s' and its verses have been uninstalled." % book_name)
	else:
		print("Book '%s' not found." % book_name)

func uninstall_translation():
	if id != null:
		# Drop the books and verses tables associated with this translation
		var drop_books_table_query = "DROP TABLE IF EXISTS %s_books;" % translation_abbr
		execute_query(drop_books_table_query)
		
		var drop_verses_table_query = "DROP TABLE IF EXISTS %s_verses;" % translation_abbr
		execute_query(drop_verses_table_query)

		# Delete the translation itself
		delete()
		print("Translation '%s' and all associated books and verses tables have been dropped." % translation_abbr)
	else:
		print("Translation ID is not set, cannot uninstall the translation.")
