extends BaseModel

class_name VerseMetaModel

#region Main variables...
var id: int = 0
var verse_hash: int = 0
var key: String = ""
var value: String = ""
#endregion

func _init():
	super._init()
	create_table()

func get_create_table_query() -> String:
	return """
	CREATE TABLE IF NOT EXISTS verse_meta (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		verse_hash INTEGER,
		key TEXT,
		value TEXT
	);
	"""

func save():
	# Check if meta entry already exists
	var query = "SELECT id FROM verse_meta WHERE verse_hash = ? AND key = ?;"
	var result = get_results(query, [verse_hash, key])
	
	if result.size() > 0:
		# Update existing meta entry
		var update_query = "UPDATE verse_meta SET value = ? WHERE verse_hash = ? AND key = ?;"
		execute_query(update_query, [value, verse_hash, key])
	else:
		# Insert new meta entry
		var insert_query = "INSERT INTO verse_meta (verse_hash, key, value) VALUES (?, ?, ?);"
		execute_query(insert_query, [verse_hash, key, value])

func get_verse_meta(verse_hash: int, key: String) -> Dictionary:
	var query = "SELECT * FROM verse_meta WHERE verse_hash = ? AND key = ?;"
	var result = get_results(query, [verse_hash, key])
	if result.size() > 0:
		self.id = result[0]["id"]
		self.verse_hash = result[0]["verse_hash"]
		self.key = result[0]["key"]
		self.value = result[0]["value"]
		return result[0]
	else:
		return {}

func get_all_verse_meta(verse_hash: int) -> Array:
	var query = "SELECT * FROM verse_meta WHERE verse_hash = ?;"
	var result = get_results(query, [verse_hash])
	return result

func get_unique_verse_meta() -> Array:
	var query = """
	SELECT * 
	FROM verse_meta 
	WHERE rowid IN (
		SELECT MIN(rowid) 
		FROM verse_meta 
		GROUP BY key
	);
	"""
	var result = get_results(query)
	return result

func get_all_verse_meta_by_key(key: String) -> Array:
	var query = "SELECT * FROM verse_meta WHERE key = ?;"
	var result = get_results(query, [key])
	return result

func delete():
	if id != 0:
		var query = "DELETE FROM verse_meta WHERE id = ?;"
		execute_query(query, [id])
	elif verse_hash != 0 and key != "":
		var query = "DELETE FROM verse_meta WHERE verse_hash = ? AND key = ?;"
		execute_query(query, [verse_hash, key])
	else:
		print("ID, verse hash, or key is not set, cannot delete the meta entry.")

func delete_by_verse_hash(verse_hash: int):
	var query = "DELETE FROM verse_meta WHERE verse_hash = ?;"
	execute_query(query, [verse_hash])
