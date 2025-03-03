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

By choosing `Export -> Export Graph to Gephi`, and importing it into Gephi, you get this:

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

## A Basic Scrollmapper to Gephi Project 

Let's not start small. To quote Tony Stark from Iron Man:

![Sometimes you gotta run before you can walk](../../images/start-big.jpg)

> "Sometimes you gotta run before you can walk."

To get a sense of working with data in Gephi, let us first export ALL of the default cross-references logged in Scrollmapper.

We will be performing these steps:

- Export cross-references as a graph / network from Scrollmapper.
- Import the cross-references graph into Gephi.
- Clean up the graph for easy viewing and analysis. 

### Export Cross References from Scrollmapper 

![Export Cross References from Gephi](../../images/t2-export.png)

To export the cross-references, simply choose the `Export Cross References Database to Gephi` option under `Export`. 

Save it to your desktop, or wherever you wish. You will notice some options for Meta items to attach. Ignore this for now.

The default filename will be `cross-references-graph.gexf`. You may change it if you wish. 

Depending on your computer, this could take a few minutes. It is taking 340,000 cross-refernces and building a `.gexf` `xml` document from them. 

### Import Cross References to Gephi 

If you have already [installed Gephi](https://gephi.org/), simply double-clicking the exported file should open it in Gephi. If not, then open Gephi and **Open**  the `.gexf` file you created.

> **NOTE** Importing it is not the method here. **Open** is the valid workflow here. 

![Open .gexf, not Import](../../images/t2-open-gexf.png)

Now you should see something like this: 

![Importing Scrollmapper nodes / edges to Gephi.](../../images/t2-import-gephi.png)

The numbers may be different if you've already saved some of your own Scrollmapper node networks to the cross-reference database. 

Push **Ok** and the graph should populate. 

![Newly imported nodes / edges from Scrollmapper.](../../images/t2-newly-imported.png)

What you are now seeing is a square of densely packed nodes and connections, or as they are called in Gephi, **nodes** and **edges**.

Let's take a moment to see the data laboratory -- the table of nodes and connections...

Push the **"Data Laboratory"** button, which is beside the **"Overview"** button. It is under **File**, **Workspace**, etc...

![Gephi Data Laboratory from Scrollmapper](../../images/t2-data-laboratory.png)

This is the starting tables that were imported from the `.gexf` file Scrollmapper generated. 

Notice there is a **Nodes** and **Edges** table. As you work with the data, you will be using these tables a lot. 

Now go back to the **Overview** tab so we can make the graph more visually sensible and easy to work with. 

![Layout options, Gephi](../../images/t2-layout-options.png)

Because of the huge amount of data, we need to distribute the nodes in a way that is efficient. A good layout option in this case is the "OpenOrd" layout. Choose "OpenOrd" from the Layout dropdown menu. 

> **NOTE** See [Why do we choose OpenOrd layout?](#why-do-we-choose-openord-layout)

![OpenOrd, no Edge Cut](../../images/t2-no-openord-edge-cut.png)

The default values for this OpenOrd layout are fine. But set the **Edge Cut** value to 0. We do not want to lose any cross-references (edges).

> **NOTE** It may seem odd seeing a few node groups floating separate from the network when you run it. That is because some cross-references are isolated. 

**Run the layout algorithm** and let it go through the process. It may take a few minutes. 

It will gradually distribute the nodes. You should end up with something like this:

![OpenOrd layout complete...](../../images/t2-layout-complete.png)

Click the black "T" button below the graph (bottom toolbar) and you should see the Verse labels: 

![Verse labels](../../images/t2-graph-labels.png)

At first the labels may seem too large, and running into each-other. Use the sliders in the bottom toolbar to change the label size. It should appear somewhat like the preview above. 

Now the fun part! We are going to make the graph more readable, colorful, and visually useful. 

For now, turn off the labels. We only wish to see the nodes at this time. 

Here is what we will do:

- Set node colors based on the book they belong to. (This is recognized as a "partition" in Gephi)
- Then we will set the node size based on degree (or relevance). This is judged by how many connects / edges a given node has. 
- Lastly we will run a layout algorithm to reduce node overlapping and deal with clutter. 

#### Set Node Colors by Book

![Partition by book](../../images/t2-color-partitions.png)

`Appearance -> Nodes -> Partition` and choose `Book` for the attribute. 

If you scroll down, you will notice that the colors desaturate to gray. We do not want this, but rather all the books should have unique colors. 

Choose `Palette` at the bottom of the `Appearance` panel. 

![Palette](../../images/t2-choose-pallete.png)

At the **top right** of this dialog, make sure `Limit number of colors` is unchecked. 

You will want to select `Generate` at the bottom. `Default` color scheme / preset is sufficient for this case. 

Next, push `Ok` and the new book colors will generate. Verify them if you wish. 

Lastly, push `Apply` at the bottom of the **Appearance** panel. 

Turn off the labels if you haven't already. 

In the toolbar left of the graph window, you can see a little magnifying glass. Click that. It will recenter the graph. 

The graph should now look something like this:

![Improved Gephi graph with colored nodes.](../../images/t2-improved-graph.png)

> **NOTE** I zoomed in using the mouse-wheel for this capture...it was zoomed out much more initially, due to outlying nodes. 

#### Set Node Size Based on Degree

Now choose `Appearance -> Nodes -> Ranking` and select `Degree` from the Attributes dropdown. 

It seems that the 10 for min, and 100 for max provide for a decent node size range in this case. You may experiment and change the values how you wish. 


![Node size by degree](../../images/t2-node-size-by-degree.png)

Here is how it should look now...

![Nodes resized](../../images/t2-nodes-resized.png)

#### Minimize Overlapping / Reduce Clutter 

This next operation may take a bit of time to process due to the large number of nodes. 

In the `Layout` panel, select `Expansion` in the dropdown. 

![Expansion algorithm](../../images/t2-scaling.png)

Set the Scale Factor to 2 and run that a few times. (I ran it 3 times.)

**Save** the graph. 

This next step (**Noverlap**) is optional, because it can take a long time. 

In the `Layout` panel, select `Noverlap` in the dropdown. 

Press `Run` and let it process. 

![Noverlap algorithm](../../images/t2-no-overlap.png)

This will take a long time. Especially on a slow computer. (You can use the `Expansion` algorithm a few times before this, and it may help the time a bit.)

### An alternative method.

The `Noverlap` Layout option - if used - will most likely do one of three things due to the amount of Nodes within this graph:

**A:** "Hang" and seemingly stop running (or not look like it is running at all).

**B:** Take an extremely long time to run if it does not "Hang".

**C:** Force you to shut down Gephi if you try to cancel the operation.

Because of this, we may use another Layout option that handles the laying out of Nodes just as well as the `OpenOrd` Layout. The `Yifan Hu` Layout.

> **NOTE** No Layout option is better than another. One Layout may excel in certain situations where others will not work so great. Some are more efficient for a given graph or situation, but no one Layout is better than another.

The `Yifan Hu` Layout is a force-directed layout algorithm designed to visualize large-scale graphs efficiently, and works by simulating physical forces between nodes, where nodes repel each other while edges act as springs pulling connected nodes together. This will ultimately give us a visually appealing, easy to understand graph Layout.

![Yifan Hu Layout Option](https://github.com/user-attachments/assets/e0681fd4-a3a4-47f6-9d8c-1043aabbeeb4)


> **NOTE** There is also another type of `Yifan Hu` Layout called `Proportional Yifan Hu` (Pictured in the image above). This one adjusts the repulsion force based on the `degree` of the nodes.

Select the `Yifan Hu` option in the Layout panel, but don't run it just yet. First, we need to adjust a few of the properties. Namely the `Optimal Distance` and `Relative Strength` parameters.

The `Optimal Distance` property dictates the preferred distance between nodes in your graph. Adjusting this property can help in creating a more readable and well-distributed layout for this graph with less overlapping Nodes. Something between 300 and 500 is good for this case. 

> **NOTE:** Higher values place nodes further apart, while lower values bring them closer together. The latter is good for small, sparse graphs, or when trying to highlight relationships. However, in our case, the graph is very large, and will look messy with so many nodes bunched together.

Next is `Relative Strength`. This adjusts the strength of the attractive and repulsive forces (the edges) between nodes. Higher values increase the influence of *attractive forces* (edges), pulling connected nodes together. Lower values increase the influence of *repulsive forces*, pushing nodes away from one another.

In this case, we have found that a value between 4.0 and 7.0 for this parameter works well, though the latter is likely to push Nodes to the borders. This is not exactly bad, as those Nodes will most likely be the Nodes with the least connections.

When you finish running the Layout, you should end up with something like this...

![Yifan Hu Result](https://github.com/user-attachments/assets/9634ec72-a551-45fe-bea0-9e827783b1a8)

The Layout has pushed Nodes away from each other, while simultaneously keeping related Nodes close to eachother. This ensures that Nodes with the least amount of connections have been placed on the outer part of the graph, with the others closer to the middle. (You can tell because the Nodes with a greater amount of connections are larger than the rest, and are concentrated *mostly* in the middle.

### Wrapping it up.

If you got this far, congratulations! You took a giant black box of messy Nodes just a few steps short of resembling Abstract Artist Jackson Pollock's "Autumn Rythm #30" and weaved it into an easier to read, colorful graph more suitable for displaying relationships in God's words. If you're happy with your graph, navigate over to the `Preview` tab so we can put a bow on this new graph of yours!

![Preview Tab](https://github.com/user-attachments/assets/ab733ebd-b3b1-49bd-ac9b-94356286b5b9)

#### Rescale Weight

> **NOTE:** Have you saved your graph? Now would be a good time to do it! Press Ctrl + S to save. If you have not saved it previously, you will need to select a location to save it to on your computer.

You will be greeted by a bit of information on the left under `Preview Settings`, and a large `Preview Panel` on the right... which is currently empty. At the bottom right of the `Preview Settings` panel, click the `Refresh` button and wait for the graph to load into the `Preview` panel.

![Refresh Preview Button](https://github.com/user-attachments/assets/c286b52a-90af-4951-a8f7-3feeca80a18c)

You should now be able to see a *Preview* of your graph, which will look something like this:

![Graph Preview](https://github.com/user-attachments/assets/92843019-69ce-4b7a-bcbb-3bef3e31ede6)

As you can see, it's not very appealing to look at for a few different reasons. Let's fix that. First, we'll resize the Edges (the lines connecting the Nodes). In the `Preview Settings` tab, scroll down to the Edges dropdown and turn `Rescale Weight` on by clicking the box.

![Rescale Weight](https://github.com/user-attachments/assets/8900e494-266d-4398-91a6-fcd29c6fe71e)

Now click the Refresh button at the bottom of the `Preview Panel` again.

##### Bonus

What did checking that box do? Well I'm glad you asked! (Yes you did, I heard you. Stop lying.) 

Checking this box has rescaled the Edges according to their 'Weight'. Remember the Data Laboratory? Pop back in there for a minute so I can show you what I mean.

![Data Laboratory](https://github.com/user-attachments/assets/cb7c9390-a2ab-491d-8188-f9dd052b94a2)

In the `Data Table` panel, click the Edges tab to swap from the Node list to the Edges list.

![Edges table](https://github.com/user-attachments/assets/13d2c4e1-b73e-47fd-931b-8098822f8f41)

Now there's a lot of numbers here, but right now the only ones you need to focus on are at the far right under the `Weight` column. If you click on 'Weight', it will toggle between sorting the edges from those with the highest Weight to the lowest, and vice versa. Here, the highest weight is 1268.0.

![Weight Column](https://github.com/user-attachments/assets/7f1285d7-7fe0-4123-9881-d7e26ec37342)

When we ticked the 'Rescale Weights' box, we visually rescaled all of the edges according to their weight. The higher the weight, the thicker the line. 'How is this helpful', I hear you ask again? (You did, stop denying it. It's a good thing, it means you're paying attention!).

The answer is it makes it easier to identify stronger and/or more significant connections in our graph! Plus it just looks nicer. Had we kept this box unchecked, all of the edges would have been one size. Now let's go back to the preview tab so we can continue.

#### Rescaling Edges

Our graph looks a bit better, now. But let's make the Edges a bit more noticeable, shall we?

As you can see, the Edges are a bit dim at the moment. Which is better than how it was before, but not quite what we want. We can change this a few different ways. You can either tweak the overall `Thickness`, which will scale the Edges relative to their weights, or you can change the `Min/Max Rescaled Weight` parameters. Let's do the former.

Leave the `Min/Max Rescaled Weight` parameters as is. Set the `Thickness` value to 100 and click `Refresh`.

![Thickness Value](https://github.com/user-attachments/assets/c4f2248f-a345-41bc-8f9e-8f1ade468e9d)



### Bonus:

I won't bore you with the mathematics behind it, but this essentially means that Edges will vary in thickness between the `Min Rescaled Weight` and `Max Rescaled Weight` based on the `Thickness` value. Let me explain:

For this situation, we have the `Min/Max Rescaled Weight` values set to 0.1 and 3.0 respectively. This means Edge Thickness will vary between 10 and 300. If the `Max Rescaled Weight` was set to 2.5, Thicknesses would now vary between 10 and 250. To make this logic easier to understand, you just need to add a 0 to the end of the `Min/Max Rescaled Weight` value decimals, then remove the decimal point. If our Thickness was 200, Edge Thicknesses would now vary between 20 and 500 - twice that of before.

I said I wouldn't bore you with the math. I lied, here's the basic formula.

*M = Min. Scaled Value*

*W = Max. Scaled Value*

*T = Thickness*

*mV = Minimum Value*

*wV = Maximum Value*

*M x T = mV*

*W x T = wV*

Or, in this case:

*0.1 x 200 = 20*

*2.5 x 200 = 500*

Thus, Edge Thicknesses - if we follow this formula - will vary between 20 and 500 based on the Edge Weights. But in this case, our Thickness will vary between 10 and 300, as our `Min/Max Rescaled Weight` values are set to 0.1 and 3.0.

#### Edge Arrows: Optional

This will only be visible if you zoom in on the graph, but to keep it uncluttered, move one tab down and look at `Edge Arrows`. Set this Value to 0.5.

![Edge Arrows](https://github.com/user-attachments/assets/f64b3ae7-02f2-4c32-be04-577135bb16a4)

#### Node Labels

Finally, let's slap some Labels onto our Nodes. We briefly covered them earlier within the Overview tab, but they work a bit differently here. Scroll up to the `Node Labels` tab and click the 'Show Labels' checkbox to turn them on, then click "Refresh" again.

![Show Labels](https://github.com/user-attachments/assets/df54b0c2-86de-474f-8c1b-61601f286518)

Your graph should be populated with Labels now. By default, the Labels will show the Book and Verse a node refers to. For example, Romans 8:31. You won't be able to rescale the nodes from the Preview tab. This is done within the Overview, so let's swap back there and rescale these Labels. Make sure to turn them on using the bottom toolbar once you get to the Overview tab.

Navigate to the `Appearance` panel and select `Label Size` as the desired Tab. It's the button with the two T's at the far right. Then switch from the tab labeled `Unique` to the one labeled `Ranking`. Set the `Attribute` to Degree, and tweak the values as you wish. Here I chose a Min/Max of 0.5 and 1.2 respectively.

![Label Size](https://github.com/user-attachments/assets/0715d8aa-7775-4d3d-9504-0ccbba9e6b32)

Once you have done this, hit apply, head back to the `Preview` tab and click "Refresh" once more. You should see that your labels have rescaled. They look small from far away, so zoom in to get a better look. You can see that the biggest Labels belong to the biggest Nodes. Or, more specifically, the Nodes with the highest Degree. Or, even more specifically, the Nodes with the most in/out connections. Remember, 'Degree' in this case is not to be confused with that thing you get for finishing a study course at college.

#### Exporting your Graph!

Congratulations! You've made your first cross-reference database in Gephi. In the bottom left corner of the Preview Settings panel, You'll see a `Preview Ratio` slider, and an `Export` button.

![Export and Preview Ratio](https://github.com/user-attachments/assets/8eaa2ffb-28cb-4c04-b50f-d28809bc73fe)

The `Preview Ratio` slider will decrease the amount of Nodes shown in the Preview Graph the lower you go. We don't really want that, so leave it as is and click `Export: SVG/PDF/PNG`. From there, all you need to do is select the file location you want to export it to, the file extension (SVG/PDF/PNG), and Export it.




### Why do we choose OpenOrd layout?

- **Scalability**: It is designed to handle large-scale graphs, making it suitable for big data visualization.
- **Cluster Detection**: OpenOrd emphasizes clustering by adjusting the position of nodes to reveal community structures within the graph.
- **Parallel Processing**: The algorithm can run in parallel, utilizing multiple cores to speed up the computation and enhance performance.
- **Phases**: OpenOrd operates in five distinct phases (liquid, expansion, cool-down, crunch, and simmer), each fine-tuning parameters like temperature and attraction to achieve an optimized layout.
- **Edge Cutting**: It uses edge cutting to promote clustering. This can be adjusted to either preserve or reduce edges, aiding in the visualization of densely connected groups.
- **Versatility**: OpenOrd's flexibility allows for both preserving all edges (setting edge cutting to 0) and aggressive clustering (increasing edge cutting).
