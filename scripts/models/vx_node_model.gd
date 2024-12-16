extends BaseModel

class_name VXNodeModel

#region Main variables...
var id: int = 0
var book: String = ""
var chapter: int = 0
var verse: int = 0
var translation: String = ""
#endregion

func _init():
	super._init()
	create_table()

func get_create_table_query() -> String:
	return """
	CREATE TABLE IF NOT EXISTS vx_nodes (
		id INTEGER PRIMARY KEY,
		book TEXT,
		chapter INTEGER,
		verse INTEGER,
		translation TEXT
	);
	"""

func save() -> int:
	# Check if node already exists
	var query = "SELECT id FROM vx_nodes WHERE book = ? AND chapter = ? AND verse = ? AND translation = ?;"
	var result = get_results(query, [book, chapter, verse, translation])
	
	if result.size() > 0:
		# Update existing node
		var update_query = "UPDATE vx_nodes SET book = ?, chapter = ?, verse = ?, translation = ? WHERE id = ?;"
		execute_query(update_query, [book, chapter, verse, translation, id])
		return result[0]["id"]
	else:
		# Insert new node
		var insert_query = "INSERT INTO vx_nodes (id, book, chapter, verse, translation) VALUES (?, ?, ?, ?, ?);"
		execute_query(insert_query, [id, book, chapter, verse, translation])
		return id

func get_all_nodes():
	var query = "SELECT * FROM vx_nodes;"
	return get_results(query)

func get_nodes_by_graph(graph_id: int) -> Array:
	var query = """
	SELECT vx_nodes.* FROM vx_nodes
	JOIN vx_graph_nodes ON vx_nodes.id = vx_graph_nodes.node_id
	WHERE vx_graph_nodes.graph_id = ?;
	"""
	return get_results(query, [graph_id])

func delete():
	if id != null:
		var query = "DELETE FROM vx_nodes WHERE id = ?;"
		execute_query(query, [id])
	else:
		print("Node ID is not set, cannot delete the node.")
