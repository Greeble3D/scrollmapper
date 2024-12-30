extends Control

class_name ProgressDialogue

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

func _ready():
	# Set the initial height of the status text
	status_text.rect_min_size.y = status_text_height

## Setter for status text
func set_status_text(new_text: String) -> void:
	status_text.text = new_text

## Setter for total amount
func set_total_amount(new_total: float) -> void:
	total_amount = new_total
	update_progress_bar()

## Setter for current amount
func set_current_amount(new_current: float) -> void:
	current_amount = new_current
	update_progress_bar()

## Update the progress bar based on the current and total amounts
func update_progress_bar() -> void:
	if total_amount > 0:
		progress_bar.value = (current_amount / total_amount) * 100
	else:
		progress_bar.value = 0
