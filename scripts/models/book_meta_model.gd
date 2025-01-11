extends BaseModel

class_name BookMetaModel

#region Main variables...
var id: int = 0
var book_hash: int = 0
var key: String = ""
var value: String = ""
#endregion

func _init():
	super._init()
	create_table()

func get_create_table_query() -> String:
	return """
	CREATE TABLE IF NOT EXISTS book_meta (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		book_hash INTEGER,
		key TEXT,
		value TEXT
	);
	"""

func save():
	# Check if meta entry already exists
	var query = "SELECT id FROM book_meta WHERE book_hash = ? AND key = ?;"
	var result = get_results(query, [book_hash, key])
	
	if result.size() > 0:
		# Update existing meta entry
		var update_query = "UPDATE book_meta SET value = ? WHERE book_hash = ? AND key = ?;"
		execute_query(update_query, [value, book_hash, key])
	else:
		# Insert new meta entry
		var insert_query = "INSERT INTO book_meta (book_hash, key, value) VALUES (?, ?, ?);"
		execute_query(insert_query, [book_hash, key, value])

func get_book_meta(book_hash: int, key: String) -> Dictionary:
	var query = "SELECT * FROM book_meta WHERE book_hash = ? AND key = ?;"
	var result = get_results(query, [book_hash, key])
	if result.size() > 0:
		self.id = result[0]["id"]
		self.book_hash = result[0]["book_hash"]
		self.key = result[0]["key"]
		self.value = result[0]["value"]
		return result[0]
	else:
		return {}

func get_all_book_meta(book_hash: int) -> Array:
	var query = "SELECT * FROM book_meta WHERE book_hash = ?;"
	var result = get_results(query, [book_hash])
	return result

func get_unique_book_meta() -> Array:
	var query = """
	SELECT * 
	FROM book_meta 
	WHERE rowid IN (
		SELECT MIN(rowid) 
		FROM book_meta 
		GROUP BY key
	);
	"""
	var result = get_results(query)
	return result

func delete():
	if id != 0:
		var query = "DELETE FROM book_meta WHERE id = ?;"
		execute_query(query, [id])
	elif book_hash != 0 and key != "":
		var query = "DELETE FROM book_meta WHERE book_hash = ? AND key = ?;"
		execute_query(query, [book_hash, key])
	else:
		print("Meta ID is not set and book_hash or key is empty, cannot delete the meta entry.")

func delete_by_book_hash(book_hash: int):
	var query = "DELETE FROM book_meta WHERE book_hash = ?;"
	execute_query(query, [book_hash])
