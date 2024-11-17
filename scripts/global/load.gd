extends Node

func _ready() -> void:
	# Create initial directories
	var data_manager = DataManager.new()
	data_manager.create_initial_directories()

	# This is necessary for runtime. 
	# In the editor, however, it is instantiated in the res://addons/cmd/cmd.gd editor script.
	var commands = Command.new()
	commands.initiate()
	commands.load_commands()
