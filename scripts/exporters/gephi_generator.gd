extends Node

## Given the appropriate node and connection data, this class generates a Gephi 
## gexf format xml string and returns it to the caller.

class_name GephiGenerator  

var gexf_template_main_template:String = ''' 
<?xml version="1.0" encoding="UTF-8"?>
<gexf xmlns="http://gexf.net/1.3" version="1.3">
	<meta lastmodifieddate="{lastmodifieddate}">
		<creator>{creator}</creator>
		<description>{description}</description>
	</meta>
	<graph mode="static" defaultedgetype="directed">
		<attributes class="node">
			<attribute id="0" title="scripture_text" type="string" />
			<attribute id="1" title="scripture_location" type="string" />
			<attribute id="2" title="translation" type="string" />
			<attribute id="3" title="book" type="string" />
			<attribute id="4" title="chapter" type="integer" />
			<attribute id="5" title="verse" type="integer" />
		</attributes>
		<nodes>
			{nodes}
		</nodes>
		<edges>
			{edges}
		</edges>
	</graph>
</gexf>
'''

var gexf_template_node_template:String = '''
<node id="{id}" label="{label}">
	<attvalues>
		<attvalue for="0" value="{scripture_text}" />
		<attvalue for="1" value="{scripture_location}" />
		<attvalue for="2" value="{translation}" />
		<attvalue for="3" value="{book}" />
		<attvalue for="4" value="{chapter}" />
		<attvalue for="5" value="{verse}" />
	</attvalues>
</node>
'''

var gexf_template_edge_template:String = '''
<edge id="{id}" source="{source}" target="{target}" />
'''

var nodes:Array = []
var edges:Array = []

func _init(_nodes: Array, _edges: Array) -> void:
	nodes = _nodes
	edges = _edges

func generate(_nodes: Array, _connections: Array) -> String:
	var gephi_nodes = {}
	var gephi_connections = []
	var node_count:int = 0 
	var connection_count:int = 0
	# Loop through nodes and build initial dictionaries
	for _node in _nodes:
		gephi_nodes[_node["id"]] = _node
	
	# Loop through connections and set up variables
	for _connection in _connections:
		# Add connection to gephi_connections array
		gephi_connections.append(_connection)

	# Export to Gephi format
	var gephi_nodes_list = []
	var gephi_edges_list = []

	for node_id in gephi_nodes.keys():
		
		var _node = gephi_nodes[node_id]
		var label:String = "%s %s:%s" % [_node["book"], str(_node["chapter"]), str(_node["verse"])]
		gephi_nodes_list.append({
			"id": _node.get("id", 0),
			"label": label,
			"scripture_text": _node.get("text", ""),
			"scripture_location": label,
			"translation": _node.get("translation", ""),
			"book": _node.get("book", ""),
			"chapter": _node.get("chapter", 0),
			"verse": _node.get("verse", 0)
		})
		node_count += 1

	for _connection in gephi_connections:
		gephi_edges_list.append({
			"id": _connection.get("id", 0),
			"source": _connection["start_node"],
			"target": _connection["end_node"]
		})
		connection_count += 1

	# Generate GEXF data
	return generate_gexf(gephi_nodes_list, gephi_edges_list, "2023-10-01", "Your Name", "Cross References Export")
	
## Function to generate the GEXF file
func generate_gexf(_nodes: Array, _edges: Array, lastmodifieddate: String, creator: String, description: String) -> String:
	var nodes_str = PackedStringArray()
	var node_counter = 0
	var total_nodes = _nodes.size()
	
	for _node in _nodes:
		var label:String = "%s %s:%s" % [_node["book"], str(_node["chapter"]), str(_node["verse"])]

		nodes_str.append(gexf_template_node_template.format({
			"id": _node["id"],
			"label": label,
			"scripture_text": _node["scripture_text"],
			"scripture_location": _node["scripture_location"],
			"translation": _node["translation"],
			"book": _node["book"],
			"chapter": str(_node["chapter"]),
			"verse": str(_node["verse"])
		}))
		
		node_counter += 1
		if node_counter % 100 == 0 or node_counter == total_nodes:
			print("%d/%d nodes completed." % [node_counter, total_nodes])
	
	var edges_str = PackedStringArray()
	var edge_counter = 0
	var total_edges = _edges.size()
	
	for _edge in _edges:
		edges_str.append(gexf_template_edge_template.format({
			"id": _edge["id"],
			"source": _edge["source"],
			"target": _edge["target"]
		}))
		
		edge_counter += 1
		if edge_counter % 100 == 0 or edge_counter == total_edges:
			print("%d/%d edges completed." % [edge_counter, total_edges])
	
	var gexf_str = gexf_template_main_template.format({
		"lastmodifieddate": lastmodifieddate,
		"creator": creator,
		"description": description,
		"nodes": "\n".join(nodes_str),
		"edges": "\n".join(edges_str)
	})

	return gexf_str
