extends BaseModel

class_name MetaModel

#region Main variables...
var id: int = 0
var meta_key: String = ""
var meta_data: String = ""
#endregion

func _init():
	super._init()
	create_table()

func get_create_table_query() -> String:
	return """
	CREATE TABLE IF NOT EXISTS meta (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		meta_key TEXT UNIQUE,
		meta_data TEXT
	);
	"""

func save():
	# Check if meta already exists
	var query = "SELECT id FROM meta WHERE meta_key = ?;"
	var result = get_results(query, [meta_key])
	
	if result.size() > 0:
		# Update existing meta
		id = result[0]["id"]
		var update_query = "UPDATE meta SET meta_data = ? WHERE id = ?;"
		execute_query(update_query, [meta_data, id])
	else:
		# Insert new meta
		var insert_query = "INSERT INTO meta (meta_key, meta_data) VALUES (?, ?);"
		execute_query(insert_query, [meta_key, meta_data])
		
		# Retrieve the last inserted ID
		result = get_results("SELECT last_insert_rowid() as id;")
		if result.size() > 0:
			id = result[0]["id"]

func get_meta_data(meta_key: String) -> Dictionary:
	var query = "SELECT * FROM meta WHERE meta_key = ?;"
	var result = get_results(query, [meta_key])

	if result.size() > 0:
		self.id = result[0]["id"]
		self.meta_key = result[0]["meta_key"]
		self.meta_data = result[0]["meta_data"]
		return result[0]
	return {}

func set_meta_data(new_meta_key: String, new_meta_data: Dictionary):
	self.meta_key = new_meta_key
	var json = JSON.new()
	self.meta_data = JSON.stringify(new_meta_data)
	save()

func delete():
	if id != null:
		var query = "DELETE FROM meta WHERE id = ?;"
		execute_query(query, [id])
	else:
		print("Meta ID is not set, cannot delete the entry.")
