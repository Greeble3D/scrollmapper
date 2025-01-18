@tool
extends Node

class_name Command

static var instance: Command = null
static var commands: Dictionary = {}
static var command_history: Array[String] = []

# This is necessary because of a double-loading issue 
# that I haven't solved yet. It is set by "res://addons/cmd/interface/cmd_interface.gd"
# in the _ready() function.
static var cmd_instance_reference = null

func _ready() -> void:
	initiate()

# This runs at runtime via res://scripts/global/load.gd
func initiate()->void:
	if instance == null:
		instance = self
	else:
		remove_child(self)
		
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
				if file_name.ends_with(".gd") || file_name.ends_with(".gd.remap"):
					file_name = file_name.replace(".remap", "")
					print("Found command: %s"%file_name.replace(".gd", "").replace(".remap", ""))
					var command_name = file_name.substr(0, file_name.length() - 3)
					var script = load(dir_path + file_name)
					if script:
						commands[command_name] = script.new()
				file_name = dir.get_next()
			dir.list_dir_end()
			for c in commands:
				print(c)

static func execute(command_string:String = ""):
	log_command(command_string)
	var command_name = ""
	var command_parts:PackedStringArray = command_string.split(" ")
	
	if command_parts.size() > 0:
		command_name = command_parts[0]
		
	if commands.has(command_name):
		var command = commands[command_name]
		command.execute(command_string)
	else:
		print("Command not found: ", command_name)

static func print_to_console(text: String):
	cmd_instance_reference.print_text(text)

static func log_command(command_string: String):
	command_history.append(command_string)
	print("Logged command: ", command_string)

static func get_command_history() -> Array:
	return command_history
