extends BaseExporter
## This class takes a VXGraph and exports it directly to the database.
class_name ExporterVXNodeToCrossReference

func _init(vx_graph: VXGraph) -> void:
	set_export_data(vx_graph.get_full_graph_as_dictionary())

func export() -> void:
	var vx_nodes = {}
	var vx_connections = []
	
	# Loop through nodes and build initial dictionaries
	for node in export_data["nodes"]:
		vx_nodes[node["id"]] = node
	
	# Loop through connections and set up variables
	for connection in export_data["connections"]:
		# Add connection to vx_connections array
		vx_connections.append(connection)
	
	for connection in vx_connections:
		if not connection["is_parallel"]:
			## We only want cross-references. Not linear narrative.
			continue

		var from_node_id = connection["start_node"]
		var to_node_id = connection["end_node"]
		
		var from_node_data = vx_nodes[from_node_id]
		var to_node_data = vx_nodes[to_node_id]

		# Populate variables for saving cross reference
		var from_book = from_node_data["book"]
		var from_chapter = from_node_data["chapter"]
		var from_verse = from_node_data["verse"]
		var to_book = to_node_data["book"]
		var to_chapter_start = to_node_data["chapter"]
		var to_chapter_end = to_node_data["chapter"]
		var to_verse_start = to_node_data["verse"]
		var to_verse_end = to_node_data["verse"]
		var votes = 0
		var user_added = true

		# Save cross reference
		ScriptureService.save_cross_reference(
			from_book,
			from_chapter,
			from_verse,
			to_book,
			to_chapter_start,
			to_chapter_end,
			to_verse_start,
			to_verse_end,
			votes,
			user_added
		)



		
