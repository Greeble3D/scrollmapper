@tool
extends Control

class_name CmdInterface

"""
CmdInterface

This class defines the command interface for the application. It handles user input,
displays output in a RichTextLabel, and applies the appropriate command style.
"""

static var instance:CmdInterface = null

@export var cmd_style_editor : CmdStyle
@export var cmd_style_app : CmdStyle

@onready var text_area: RichTextLabel = $TextArea
@onready var cmd_input: LineEdit = $CmdInput

# The current command style (abbreviated for easy coding use)
var ccs:CmdStyle 

# Called when the node is added to the scene.
func _ready() -> void:
	if instance == null:
		instance = self
		
	text_area.size_flags_vertical = Control.SIZE_EXPAND_FILL  # Expand to take all available vertical space
	text_area.bbcode_enabled = true  # Ensure BBCode is enabled

	cmd_input.size_flags_vertical = Control.SIZE_SHRINK_CENTER  # Maintain its size at the bottom
	cmd_input.text_submitted.connect(submit)
	ccs = cmd_style_app
	if Engine.is_editor_hint():
		ccs = cmd_style_editor


# Called when the node is removed from the scene.
func _exit_tree() -> void:
	instance = null

# Handles the submission of a command.
# @param command_text: The text of the command to be executed.
func submit(command_text: String) -> void:
	if Command.instance == null:
		print("Command.instance is null.")
		return	
	print_text(command_text)
	cmd_input.clear()
	Command.execute(command_text)
	
# Prints text to the text area.
# @param text: The text to be printed.
static func print_text(text: String) -> void:
	if instance.ccs == null:
		instance.ccs = instance.cmd_style_editor
	var text_area: RichTextLabel = instance.text_area

	text_area.append_text(text + "\n")

# Handles key press events to cycle through command history.
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed:
			if event.is_action_pressed("ui_up"):
				cycle_command_history(-1)
			elif event.is_action_pressed("ui_down"):
				cycle_command_history(1)

# Cycles through the command history.
# @param direction: The direction to cycle (-1 for up, 1 for down).
var history_index: int = -1
func cycle_command_history(direction: int) -> void:
	if Command.command_history.size() == 0:
		return

	history_index += direction
	if history_index < 0:
		history_index = Command.command_history.size() - 1
	elif history_index >= Command.command_history.size():
		history_index = 0

	cmd_input.text = Command.command_history[history_index]
