extends BaseExporter
## This class takes a VXGraph and exports it to Gephi format.
class_name ExporterVXGraphToGephi

var gephi_generator: GephiGenerator
var save_path:String = ""

func _init(vx_graph: VXGraph, _save_path:String) -> void:
	save_path = _save_path
	set_export_data(vx_graph.get_full_graph_as_dictionary())
	gephi_generator = GephiGenerator.new(export_data["nodes"], export_data["connections"])

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
