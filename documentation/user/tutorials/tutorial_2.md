# Scrollmapper - Tutorial 2: Using Scrollmapper with Gephi

Integrating Scrollmapper with [Gephi](https://gephi.org/) opens up powerful possibilities for analyzing biblical texts. Scrollmapper includes 340,000 cross-references from [openbible.info](https://www.openbible.info/labs/cross-references/), providing a rich dataset for big-data analysis.

## Gephi Integration

With Scrollmapper's extensive dataset, you can leverage Gephi's advanced graph analysis tools to uncover intricate relationships within the scriptures.

![Gephi Graph 1](../../images/gephi-graph-1.png)

![Gephi Graph 2](../../images/gephi-graph-2.png)

For those familiar with Gephi, the potential is vast. You can visualize and analyze the connections between different parts of the Bible, identify central themes, and explore the structure of biblical narratives. Gephi's capabilities allow for in-depth exploration of canonical scriptures, revealing patterns and insights that might not be immediately apparent through traditional study methods.

## Scrollmapper -> Gephi Basics

Scrollmapper exports to Gephi using the **[.gexf](https://gexf.net/)** format. Opening the .gexf file will reveal an entire network of connected verses ready for Gephi editing and analysis.

Using the simple example from [Tutorial 1](tutorial_1.md), let us export a basic graph to Gephi.

Here it is in Scrollmapper:

![From Scrollmapper, Prepared for Gephi:](../../images/enoch-job-wisdom-connection.png)

By choosing Export -> Export Graph to Gephi, and importing it into Gephi, you get this:

![Exported Scrollmapper Graph in Gephi](../../images/job-enoch-gephi.png)

This small graph provides you with quite a bit of information:

![Gephi Data Laboratory](../../images/gephi-scrollmapper-data-laboratory.png)

Here are the default attributes that are available for every node in Gephi:

- Id
- Label
- scripture_text
- scripture_location
- translation
- book
- chapter
- verse

If you export from Scrollmapper with custom attributes (using Scrollmapper's verse meta feature), you can have even more attributes to filter/work with in Gephi.

For example, by having the verse text available, you can search all nodes according to the text the scriptures contain:

![Verse Search](../../images/verse-search-gephi.png)

This might not seem like much, but with a dataset of thousands of connected verses, Gephi becomes very useful for analyzing data.

Here is a quick-generated graph of the *minor prophets* and their relationships to each other:


![Minor prophets, Gephi Graph](../../images/gephi-render-2.png)

> **NOTE** Organizing and isolating node groups is a huge focus in Gephi. However in this case, we've run some auto-layouts for a quick result. 

And the corresponding data laboratory:

![Minor Prophets, Gephi Data Lab](../../images/gephi-data-lab-minor-prophets.png)

You can see that Gephi editing and analysis adds many new metrics to study the data on. This is a specialized subject that can go as deep as you want it to.

So let's give a small tutorial on how to productively analyze scripture data exported from Scrollmapper.