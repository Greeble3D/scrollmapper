extends Control

class_name ProgressDialogue


#region standard stuff
## Standard BaseDialogue variable required. 
var base_dialogue:BaseDialogue = null

@export var file_destination_line_edit: LineEdit
@export var file_select_button: Button

@export var title:String = ""
@export var file_path:String = ""
#endregion

## The text that will be regularly updated progress of process
@export var status_text: RichTextLabel 

## The progress bar itself
@export var progress_bar: ProgressBar 

## The height of the rich text label, which may vary based on amount of 
## information to be updated.
@export var status_text_height: int = 40


## Total / goal amount, or total iterations of a process, such 5000 total scriptures.
@export var total_amount: float = 100:
	set(value):
		total_amount = value
		set_total_amount(value)

## The current amount of iterations completed. Such as 1000 of the 5000 total scriptures.
@export var current_amount: float = 0:
	set(value):
		current_amount = value
		set_current_amount(value)

func _ready() -> void:
	base_dialogue.set_minimum_size(Vector2(500, 150))

## Setup. This is a required function that takes the BaseDialogue
## Making a new exporter? Just copy/paste this to the new script.
func setup(_base_dialogue:BaseDialogue) -> void:
	base_dialogue = _base_dialogue
	base_dialogue.accepted.connect(_on_accepted)
	base_dialogue.closed.connect(_on_closed)
	base_dialogue.set_title(title)
	
	base_dialogue.hide_accept_button = true
	base_dialogue.hide_close_button = true


## Required function for when the Accept button is pushed. 
## Functionality initiated here. 
func _on_accepted() -> void:
	pass

## Required function for closing the parent. 
func _on_closed() -> void:
	pass

## Setter for status text
func set_status_text(new_text: String) -> void:
	status_text.text = new_text

## Setter for total amount
func set_total_amount(new_total: float) -> void:
	update_progress_bar()

## Setter for current amount
func set_current_amount(new_current: float) -> void:
	update_progress_bar()

## Update the progress bar based on the current and total amounts
func update_progress_bar() -> void:
	progress_bar.max_value = total_amount
	progress_bar.value = current_amount
