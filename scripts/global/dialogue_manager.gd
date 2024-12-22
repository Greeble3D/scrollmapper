extends Node

const BASE_DIALOGUE = preload("res://scenes/modules/dialogues/base_dialogue.tscn")


## Function: create_dialogue
## Description: Creates a dialogue and adds it to the specified anchor node.
## This is a generic function that can be used to create any dialogue.
## 
## Parameters:
## - content (Control): The content of the dialogue. This must be a Control node.
## - anchor_to (Node): The node to which the content will be added as a child.
# 
## Usage:
## Call this function with the dialogue content and the node you want to anchor it to.
## Example:
## create_dialogue(dialogue_content, anchor_node)
func create_dialogue(content:Control, anchor_to:Node) -> Control:
	var bd:BaseDialogue = BASE_DIALOGUE.instantiate()
	bd.set_content(content)
	content.base_dialogue = bd
	anchor_to.add_child(bd)
	return bd
