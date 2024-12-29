extends Node

class_name LoadLevelCommand

# Handles the execution of the load_level command.
func execute(command_string: String) -> void:
	var parser = ArgParser.new()
	parser.add_option("-l", "--level", "Level", "")
	parser.add_option("-c", "--custom", "Custom", "")
	parser.parse(command_string.split(" "))

	var level: String = parser.get_option("-l")
	var custom: String = parser.get_option("-c")

	if level == "":
		Command.print_to_console("Level not provided.")
		print("Level not provided.")
		return

	GameManager.load_level(level, custom)
	Command.print_to_console("Level '%s' loaded with custom '%s'." % [level, custom])
