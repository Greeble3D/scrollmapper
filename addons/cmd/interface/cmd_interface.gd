@tool
extends Control

class_name CmdInterface

static var instance:CmdInterface = null

@onready var text_area: TextEdit = $TextArea
@onready var cmd_input: LineEdit = $CmdInput

func _ready() -> void:
	if instance == null:
		instance = self
		
	text_area.size_flags_vertical = Control.SIZE_EXPAND_FILL  # Expand to take all available vertical space
	cmd_input.size_flags_vertical = Control.SIZE_SHRINK_CENTER  # Maintain its size at the bottom
	cmd_input.name = "CMD LineEdit"
	cmd_input.text_submitted.connect(submit)

func _exit_tree() -> void:
	instance = null

func submit(new_text: String) -> void:
	text_area.text += "%s\n"%new_text
	cmd_input.clear()
	text_area.get_v_scroll_bar().value = text_area.get_v_scroll_bar().max_value
	if Command.instance == null:
		print("Command.instance is null...")
		return
	Command.execute(new_text)
