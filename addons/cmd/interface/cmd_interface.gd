@tool
@icon("res://images/icons/editor/Terminal.svg")
extends Control

class_name CmdInterface

"""
CmdInterface

This class defines the command interface for the application. It handles user input,
displays output in a RichTextLabel, and applies the appropriate command style.
"""

static var instance:CmdInterface = null

const CMD_STYLE_APP = preload("res://addons/cmd/interface/styles/cmd_styles/cmd_style_app.tres")
const CMD_STYLE_EDITOR = preload("res://addons/cmd/interface/styles/cmd_styles/cmd_style_editor.tres")

@export var cmd_style_editor : CmdStyle 
@export var cmd_style_app : CmdStyle

@export var controls_container: VBoxContainer
@export var text_area: RichTextLabel 
@export var cmd_input: LineEdit 

# The current command style (abbreviated for easy coding use)
var ccs:CmdStyle

static func initiate() -> void:
	var cmd_interface:CmdInterface = CmdInterface.new()

# Called when the node is added to the scene.
func _ready() -> void:
	instance = self
	
	# This is a temporary solution to a problem where this class
	# instance variable sometimes becomes null, although in fact
	# it seems that it is only being static instanced once. 
	if Command.cmd_instance_reference == null:
		Command.cmd_instance_reference = self
		
	controls_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	text_area.size_flags_vertical = Control.SIZE_EXPAND_FILL  # Expand to take all available vertical space
	text_area.bbcode_enabled = true  # Ensure BBCode is enabled

	cmd_input.size_flags_vertical = Control.SIZE_SHRINK_CENTER  # Maintain its size at the bottom
	cmd_input.text_submitted.connect(submit)
	
	# Apply the dynamic styles for editor or app mode.
	apply_mode_styles()
	

# Called when the node is removed from the scene.
func _exit_tree() -> void:
	instance = null

# Applies the appropriate command style to the interface based on 
# the current mode (app or editor).
func apply_mode_styles():
	ccs = cmd_style_app
	if Engine.is_editor_hint():		
		ccs = cmd_style_editor
	var style_box: StyleBoxFlat = get_theme_stylebox("panel").duplicate()
	style_box.bg_color = ccs.background_color
	add_theme_stylebox_override("panel", style_box)

# Handles the submission of a command.
# @param command_text: The text of the command to be executed.
func submit(command_text: String) -> void:
	if Command.instance == null:
		print("Command.instance is null.")
		return	
	cmd_input.clear()
	Command.execute(command_text)
	
# Prints text to the text area.
# @param text: The text to be printed.
func print_text(text: String) -> void:	
	var text_area: RichTextLabel = text_area
	await get_tree().create_timer(0.2).timeout
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

static func get_cmd_style():
	if instance == null:
		instance = CmdInterface.new()
	return instance.ccs
