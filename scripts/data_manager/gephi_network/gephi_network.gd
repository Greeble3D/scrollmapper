extends Node 

## The main containing class for creating a valid gephi network of nodes and connections.

class_name GephiNetwork

## The date when the network was last modified.
var last_modified_date: String

## The creator of the network.
var creator: String

## A description of the network.
var description: String

## A dictionary containing the nodes of the network.
## Accessed as <id>:<GephiNode>
var nodes: Dictionary = {}

## A dictionary containing the edges of the network.
## Accessed as <id>:<GephiEdge>
var edges: Dictionary = {}

## The highest edge weight value in the network.
var highest_edge_weight: float = 0.0
## The lowest edge weight value in the network.
var lowest_edge_weight: float = 0.0

## Initialize the network with the last modified date, creator, description, nodes, and edges.
func _init(_last_modified_date: String, _creator: String, _description: String, _nodes:Array, _edges:Array) -> void:
	last_modified_date = _last_modified_date
	creator = _creator
	description = _description
	for node in _nodes:
		self.add_node(node)
	for edge in _edges:
		self.add_edge(edge)
	adjust_edge_weights()

## Get the nodes of the network as an array.
func get_nodes_array() -> Array:
	return nodes.values()

## Get the edges of the network as an array.
func get_edges_array() -> Array:
	return edges.values()

## Add a node to the network.
func add_node(node_data: Dictionary) -> GephiNode:
	var node = GephiNode.new()
	node.scripture_text = node_data.get("scripture_text", "")
	node.scripture_location = node_data.get("scripture_location", "")
	node.translation = node_data.get("translation", "")
	node.book = node_data.get("book", "")
	node.chapter = node_data.get("chapter", 0)
	node.verse = node_data.get("verse", 0)
	nodes[node_data.get("id")] = node
	return node

## Add an edge to the network.
func add_edge(edge_data: Dictionary) -> GephiEdge:
	var edge = GephiEdge.new()
	edge.source = edge_data.get("source", 0)
	edge.target = edge_data.get("target", 0)
	edge.weight = edge_data.get("weight", 1)
	if edge.weight == 0:
		edge.weight = 1
	edges[edge_data.get("id")] = edge
	
	# Update highest and lowest edge weight
	if edge.weight > highest_edge_weight:
		highest_edge_weight = edge.weight
	if lowest_edge_weight == 0 or edge.weight < lowest_edge_weight:
		lowest_edge_weight = edge.weight
	
	return edge

## Adjust the edge weights in the network.
## Edge weights must be positive, not negative. So this function will adjust the weights accordingly
## by looking at highest_edge_weight and lowest_edge_weight and offsetting the value of each connection 
## so that weights are at minimum 1, and the highest weight is the highest_edge_weight.
func adjust_edge_weights() -> void:
	var offset = 1
	var range = highest_edge_weight - lowest_edge_weight
	if range == 0:
		range = 1
	for edge in edges.values():
		edge.weight = (edge.weight - lowest_edge_weight) / range * (highest_edge_weight - offset) + offset

## Generate the GEXF XML string for the network.
func generate_gexf() -> String:
	var gephi_gexf = GephiGexf.new(self)
	return gephi_gexf.get_gexf_xml().strip_edges()
