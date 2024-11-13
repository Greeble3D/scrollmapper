@tool
extends Node

class_name Command

static var instance: Command = null
static var commands: Dictionary = {}

func initiate():
	if instance == null:
		instance = self

func load_commands():
	commands.clear()

	var directories = [
		"res://scripts/commands/"
	]
	for dir_path in directories:
		var dir = DirAccess.open(dir_path)
		if dir:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if file_name.ends_with(".gd"):
					var command_name = file_name.substr(0, file_name.length() - 3)
					var script = load(dir_path + file_name)
					if script:
						commands[command_name] = script.new()
				file_name = dir.get_next()
			dir.list_dir_end()

static func execute(command_string:String = ""):
	var command_name = ""
	var command_parts:PackedStringArray = command_string.split(" ")
	
	if command_parts.size() > 0:
		command_name = command_parts[0]
		
	if commands.has(command_name):
		var command = commands[command_name]
		command.execute(command_string)
	else:
		print("Command not found: ", command_name)
