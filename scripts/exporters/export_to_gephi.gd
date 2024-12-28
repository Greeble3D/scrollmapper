extends BaseExporter

## This class takes a VXGraph and exports it to Gephi format.
class_name ExporterVXGraphToGephi

var gephi_network: GephiNetwork
var save_path: String = ""

func _init(vx_graph: VXGraph, _save_path: String) -> void:
	save_path = _save_path
	set_export_data(vx_graph.get_full_graph_as_dictionary())
	var nodes: Array = []
	var edges: Array = []
	var node_ids: Dictionary = {}
	var edge_id: int = 0

	for node_data in export_data["nodes"]:
		var node_id: int = node_data["id"]
		if not node_ids.has(node_id):
			nodes.append({
				"id": node_id,
				"scripture_text": node_data.get("text", ""),
				"scripture_location": node_data.get("scripture_location", ""),
				"translation": node_data.get("translation", ""),
				"book": node_data.get("book", ""),
				"chapter": node_data.get("chapter", 0),
				"verse": node_data.get("verse", 0)
			})
			node_ids[node_id] = true

	for edge_data in export_data["connections"]:
		edges.append({
			"id": edge_id,
			"source": edge_data.get("start_node", 0),
			"target": edge_data.get("end_node", 0),
			"weight": edge_data.get("is_parallel", 1)
		})
		edge_id += 1

	gephi_network = GephiNetwork.new("", "Creator Name", "Description", nodes, edges)

func export() -> void:
	# Generate GEXF data using GephiNetwork
	var gexf_data: String = gephi_network.generate_gexf()

	# Save to File 
	save_to_file(gexf_data)

func save_to_file(content: String) -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(content)
	file.close()
