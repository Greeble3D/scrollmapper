extends BaseModel

## This is the M2M (many-to-many) model for the graph-node relationship.

class_name VXGraphNodeModel

#region Main variables...
var graph_id: int = 0
var node_id: int = 0
#endregion

func _init():
	super._init()
	create_table()

func get_create_table_query() -> String:
	return """
	CREATE TABLE IF NOT EXISTS vx_graph_nodes (
		graph_id INTEGER,
		node_id INTEGER,
		FOREIGN KEY(graph_id) REFERENCES graphs(id),
		FOREIGN KEY(node_id) REFERENCES nodes(id),
		PRIMARY KEY (graph_id, node_id)
	);
	"""

func save():
	# Check if graph-node relationship already exists
	var query = "SELECT * FROM vx_graph_nodes WHERE graph_id = ? AND node_id = ?;"
	var result = get_results(query, [graph_id, node_id])
	
	if result.size() == 0:
		# Insert new graph-node relationship
		var insert_query = "INSERT INTO vx_graph_nodes (graph_id, node_id) VALUES (?, ?);"
		execute_query(insert_query, [graph_id, node_id])

func get_nodes_by_graph(graph_id: int) -> Array:
	var query = "SELECT node_id FROM vx_graph_nodes WHERE graph_id = ?;"
	return get_results(query, [graph_id])

func delete():
	if graph_id != null and node_id != null:
		var query = "DELETE FROM vx_graph_nodes WHERE graph_id = ? AND node_id = ?;"
		execute_query(query, [graph_id, node_id])
	else:
		print("Graph ID or Node ID is not set, cannot delete the relationship.")