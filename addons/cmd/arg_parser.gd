extends Object

class_name ArgParser

var options = {}
var flags = []
var arguments = []

func _init():
	# Initialize options, flags, and arguments
	pass

func add_option(short_flag: String, long_flag: String, description: String, default_value=null):
	options[short_flag] = {"long": long_flag, "description": description, "value": default_value}
	options[long_flag] = options[short_flag]

func add_flag(short_flag: String, long_flag: String, description: String):
	flags.append({"short": short_flag, "long": long_flag, "description": description, "value": false})

func parse(args: Array):
	var skip_next = false
	for i in range(args.size()):
		if skip_next:
			skip_next = false
			continue
		
		var arg = args[i]
		if arg.begins_with("--"):
			if arg in options:
				options[arg]["value"] = args[i + 1] if i + 1 < args.size() else null
				skip_next = true
			elif arg in flags.map(func(f): return f["long"]):
				for flag in flags:
					if flag["long"] == arg:
						flag["value"] = true
		elif arg.begins_with("-"):
			if arg in options:
				options[arg]["value"] = args[i + 1] if i + 1 < args.size() else null
				skip_next = true
			elif arg in flags.map(func(f): return f["short"]):
				for flag in flags:
					if flag["short"] == arg:
						flag["value"] = true
		else:
			arguments.append(arg)

func get_option(short_flag: String):
	return options[short_flag]["value"]

func get_flag(short_flag: String):
	for flag in flags:
		if flag["short"] == short_flag:
			return flag["value"]
	return false

func print_help():
	print("Options:")
	for key in options.keys():
		var opt = options[key]
		print("%s, %s: %s (default: %s)" % [key, opt["long"], opt["description"], opt["value"]])
	
	print("\nFlags:")
	for flag in flags:
		print("%s, %s: %s" % [flag["short"], flag["long"], flag["description"]])
