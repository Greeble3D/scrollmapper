extends BaseModel

## This is the model for the vx_connection.

class_name VXConnectionModel

#region Main variables...
var id: int = 0
var text: String = ""
var start_node_id: int = 0
var end_node_id: int = 0
var is_parallel: bool = true
#endregion

func _init():
	super._init()
	create_table()

func get_create_table_query() -> String:
	return """
	CREATE TABLE IF NOT EXISTS vx_connections (
		id INTEGER PRIMARY KEY,
		text TEXT,
		start_node_id INTEGER,
		end_node_id INTEGER,
		is_parallel BOOLEAN DEFAULT TRUE,
		FOREIGN KEY(start_node_id) REFERENCES nodes(id),
		FOREIGN KEY(end_node_id) REFERENCES nodes(id)
	);
	"""

## Save the connection to the database.
## If the connection already exists, update it.
## If the connection is new, insert it.
## Return the ID of the connection.
func save() -> int:
	# Check if connection already exists
	var query = "SELECT id FROM vx_connections WHERE start_node_id = ? AND end_node_id = ?;"
	var result = get_results(query, [start_node_id, end_node_id])
	
	if result.size() > 0:
		# Update existing connection
		var update_query = "UPDATE vx_connections SET text = ?, is_parallel = ? WHERE id = ?;"
		execute_query(update_query, [text, is_parallel, id])
		return result[0]["id"]
	else:
		# Insert new connection
		var insert_query = "INSERT INTO vx_connections (id, text, start_node_id, end_node_id, is_parallel) VALUES (?, ?, ?, ?, ?);"
		execute_query(insert_query, [id, text, start_node_id, end_node_id, is_parallel])
		return get_last_inserted_id()

func get_all_connections():
	var query = "SELECT * FROM vx_connections;"
	return get_results(query)

func get_connections_by_graph(graph_id: int) -> Array:
	var query = """
	SELECT vx_connections.* FROM vx_connections
	JOIN vx_graph_connections ON vx_connections.id = vx_graph_connections.connection_id
	WHERE vx_graph_connections.graph_id = ?;
	"""
	return get_results(query, [graph_id])

func delete():
	if id != null:
		var query = "DELETE FROM vx_connections WHERE id = ?;"
		execute_query(query, [id])
	else:
		print("Connection ID is not set, cannot delete the connection.")
