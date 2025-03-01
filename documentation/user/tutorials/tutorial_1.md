# Scrollmapper - Tutorial 1: Using the Node System

In the main graphing area, you will find a canvas where you can create connected nodes. You will also have various options for saving, exporting, and working with the nodes.

## Overview of Graph Options
![Graph Options](../../images/graph-options.png)

List of graph control functions and operations:

- **Search Bar (left)** The main search mechanism for adding verses to the graph, either one-by-one or in mass amounts. Can search by word or range.
- **Controls Area (right)** Settings, saving, exporting, importing, and meta controls.

> **Note** You will mainly work with the search bar to bring new verse nodes into the VX Graph. (VX Graph is the name of our scripture mapping system, which stands for Cross-Verse).

### Graph Dropdown

![Graph Dropdown](../../images/graph-options-2.png)

- **Settings** This is the main info settings for the graph. At this time you may save its title and description.
- **Save** Saves the graph.
- **Load** Loads a graph.
- **Delete Graph** Deletes the currently open graph.
- **New Graph** Creates a new blank graph.
- **Exit** Brings you back to the home screen of the Scrollmapper app.

### Import Dropdown

![Import](../../images/import.png)

- **Import from JSON** When a user exports a graph, it is exported as a JSON object. This can re-import a graph from JSON.
    - > **Note** If a user creates a graph using a book not currently in your library, then the nodes for that book will not import. Collaboration and communication between users and projects are necessary here.
- **Import User-created Cross References from CSV** If a user exports a list of cross-references they had created (in the export options), it can be re-imported here. These will be imported to the database (not to a graph).

### Export Dropdown

![Export](../../images/export.png)

- **Export to Cross-References** Saves your graph to the cross-references database. This is technically an export operation, which is why it is named such.
- **Export Graph to Gephi** Will export the graph as a **[.gexf](https://gexf.net/)** file for use in **[Gephi](https://gephi.org/)**.
- **Export Cross-References Database to Gephi** This will export the ENTIRE cross-reference database to **[Gephi](https://gephi.org/)**. This will make an extremely large graph/dataset as Scrollmapper already contains 34,000 cross-references to start. Whatever you have exported to the cross-reference database will also be included.
- **Export as JSON** Will export the graph as a JSON object, which other users may import again. This is useful for collaboration.
- **Export User-Created Cross References to CSV** Will export chosen sets of cross-references to CSV format, which can be used in other apps or databases.

### Edit Meta
This is an advanced option for editing meta keys. These are used for isolating data later in **[Gephi](https://gephi.org/)**. 

