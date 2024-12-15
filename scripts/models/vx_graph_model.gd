extends BaseModel

## This is the base model for vx_graph.

class_name VXGraphModel

#region Main variables...
var id: int = 0
var graph_name: String = ""
var graph_description: String = ""
#endregion

func _init():
	super._init()
	create_table()

func get_create_table_query() -> String:
	return """
	CREATE TABLE IF NOT EXISTS vx_graphs (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		graph_name TEXT,
		graph_description TEXT
	);
	"""

func save() -> int:
	# Check if graph already exists
	var query = "SELECT id FROM vx_graphs WHERE id = ?;"
	var result = get_results(query, [id])
	
	if result.size() > 0:
		# Update existing graph
		var update_query = "UPDATE vx_graphs SET graph_name = ?, graph_description = ? WHERE id = ?;"
		execute_query(update_query, [graph_name, graph_description, id])
		return result[0]["id"]
	else:
		# Insert new graph
		var insert_query = "INSERT INTO vx_graphs (graph_name, graph_description) VALUES (?, ?);"
		execute_query(insert_query, [graph_name, graph_description])
		id = get_last_inserted_id()
		return id

func get_graph_by_id(graph_id: int) -> Dictionary:
	var query = "SELECT * FROM vx_graphs WHERE id = ?;"
	var result = get_results(query, [graph_id])
	
	if result.size() > 0:
		var row = result[0]
		id = row["id"]
		graph_name = row["graph_name"]
		graph_description = row["graph_description"]
		return result[0]
	else:
		return {}

func get_all_graphs():
	var query = "SELECT * FROM vx_graphs;"
	return get_results(query)



func delete():
	if id != null:
		var query = "DELETE FROM vx_graphs WHERE id = ?;"
		execute_query(query, [id])
	else:
		print("Graph ID is not set, cannot delete the graph.")