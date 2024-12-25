extends BaseExporter
## This class takes a VXGraph and exports it to Gephi format.
class_name ExporterCrossReferencesToGephi

var gephi_generator: GephiGenerator
var save_path:String = ""

func _init(_save_path:String) -> void:
	save_path = _save_path
	populate_export_data()
	gephi_generator = GephiGenerator.new(export_data["nodes"], export_data["connections"])

func populate_export_data():
	var cross_references:Array = ScriptureService.get_all_cross_references_simple()
	export_data["nodes"] = []
	export_data["connections"] = []

	var nodes = []
	var edges = []
	var node_ids = {}
	var edge_id = 0

	for cross_reference in cross_references:
		var from_node_id = "%s-%d-%d" % [cross_reference["from_book"], cross_reference["from_chapter"], cross_reference["from_verse"]]
		var to_node_id = "%s-%d-%d" % [cross_reference["to_book"], cross_reference["to_chapter_start"], cross_reference["to_verse_start"]]


		var connection_id:int = cross_reference["id"]
		var from_book:String = cross_reference["from_book"]
		var from_chapter:int = cross_reference["from_chapter"]
		var from_verse:int = cross_reference["from_verse"]
		var to_book:String = cross_reference["to_book"]
		var to_chapter_start:int = cross_reference["to_chapter_start"]
		var to_chapter_end:int = cross_reference["to_chapter_end"]
		var to_verse_start:int = cross_reference["to_verse_start"]
		var to_verse_end:int = cross_reference["to_verse_end"]

		if not node_ids.has(from_node_id):
			nodes.append({
				"id": from_node_id,
				"label": from_node_id,
				"scripture_text": "",
				"scripture_location": from_node_id,
				"translation": "",
				"book": cross_reference["from_book"],
				"chapter": cross_reference["from_chapter"],
				"verse": cross_reference["from_verse"]
			})
			node_ids[from_node_id] = true
			

		if not node_ids.has(to_node_id):
			nodes.append({
				"id": to_node_id,
				"label": to_node_id,
				"scripture_text": "",
				"scripture_location": to_node_id,
				"translation": "",
				"book": cross_reference["to_book"],
				"chapter": cross_reference["to_chapter_start"],
				"verse": cross_reference["to_verse_start"]
			})
			node_ids[to_node_id] = true

		edges.append({
			"id": edge_id,
			"start_node": from_node_id,
			"end_node": to_node_id
		})
		edge_id += 1
	export_data["nodes"] = nodes	
	export_data["connections"] = edges

func export() -> void:
	var vx_nodes = export_data["nodes"]
	var vx_connections = export_data["connections"]

	# Generate GEXF data using GephiGenerator
	var gexf_data:String = gephi_generator.generate(vx_nodes, vx_connections).strip_edges()

	# Save to File 
	save_to_file(gexf_data)

func save_to_file(content):
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(content)
