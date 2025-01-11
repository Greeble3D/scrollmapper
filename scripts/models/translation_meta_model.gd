extends BaseModel

class_name TranslationMetaModel

#region Main variables...
var id: int = 0
var translation_hash: int = 0
var key: String = ""
var value: String = ""
#endregion

func _init():
	super._init()
	create_table()

func get_create_table_query() -> String:
	return """
	CREATE TABLE IF NOT EXISTS translation_meta (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		translation_hash INTEGER,
		key TEXT,
		value TEXT
	);
	"""

func save():
	# Check if meta entry already exists
	var query = "SELECT id FROM translation_meta WHERE translation_hash = ? AND key = ?;"
	var result = get_results(query, [translation_hash, key])
	
	if result.size() > 0:
		# Update existing meta entry
		var update_query = "UPDATE translation_meta SET value = ? WHERE translation_hash = ? AND key = ?;"
		execute_query(update_query, [value, translation_hash, key])
	else:
		# Insert new meta entry
		var insert_query = "INSERT INTO translation_meta (translation_hash, key, value) VALUES (?, ?, ?);"
		execute_query(insert_query, [translation_hash, key, value])

func get_translation_meta(translation_hash: int, key: String) -> Dictionary:
	var query = "SELECT * FROM translation_meta WHERE translation_hash = ? AND key = ?;"
	var result = get_results(query, [translation_hash, key])
	if result.size() > 0:
		self.id = result[0]["id"]
		self.translation_hash = result[0]["translation_hash"]
		self.key = result[0]["key"]
		self.value = result[0]["value"]
		return result[0]
	else:
		return {}

func get_all_translation_meta(translation_hash: int) -> Array:
	var query = "SELECT * FROM translation_meta WHERE translation_hash = ?;"
	var result = get_results(query, [translation_hash])
	return result

func get_unique_translation_meta() -> Array:
	var query = """
	SELECT * 
	FROM translation_meta 
	WHERE id IN (
		SELECT MIN(id) 
		FROM translation_meta 
		GROUP BY key
	);
	"""
	var result = get_results(query)
	return result

func delete():
	if id != 0:
		var query = "DELETE FROM translation_meta WHERE id = ?;"
		execute_query(query, [id])
	elif translation_hash != 0 and key != "":
		var query = "DELETE FROM translation_meta WHERE translation_hash = ? AND key = ?;"
		execute_query(query, [translation_hash, key])
	else:
		print("Meta ID is not set, and either translation_hash or key is empty. Cannot delete the meta entry.")

func delete_by_translation_hash(translation_hash: int):
	var query = "DELETE FROM translation_meta WHERE translation_hash = ?;"
	execute_query(query, [translation_hash])
