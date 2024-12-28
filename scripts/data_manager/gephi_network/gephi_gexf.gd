extends Node

## Initializes with a GephiNetwork object, and populates a valid gexf format string for Gephi.
class_name GephiGexf

var main_template:String = ''' 
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

var node_template:String = '''
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

var edge_template:String = '''
<edge id="{id}" source="{source}" target="{target}" weight="{weight}" />
'''

var gexf_xml:String = ""

func _init(gephi_network: GephiNetwork) -> void:
    var nodes_str = PackedStringArray()
    var edges_str = PackedStringArray()
    
    for node_id in gephi_network.nodes.keys():
        var node = gephi_network.nodes[node_id]
        var label = "%s %s:%s" % [node.book, str(node.chapter), str(node.verse)]
        
        nodes_str.append(node_template.format({
            "id": node_id,
            "label": label,
            "scripture_text": node.scripture_text,
            "scripture_location": label,
            "translation": node.translation,
            "book": node.book,
            "chapter": str(node.chapter),
            "verse": str(node.verse)
        }))
    
    for edge_id in gephi_network.edges.keys():
        var edge = gephi_network.edges[edge_id]
        
        edges_str.append(edge_template.format({
            "id": edge_id,
            "source": str(edge.source),
            "target": str(edge.target),
            "weight": str(edge.weight)
        }))
    
    var gexf_str = main_template.format({
        "lastmodifieddate": gephi_network.last_modified_date,
        "creator": gephi_network.creator,
        "description": gephi_network.description,
        "nodes": "\n".join(nodes_str),
        "edges": "\n".join(edges_str)
    })
    
    gexf_xml = gexf_str

## Returns the gexf xml string.
func get_gexf_xml() -> String:
    return gexf_xml