@tool
extends Node

func execute(command_string: String):
	var args: PackedStringArray = command_string.split(" ")
	var parser = ArgParser.new()
	
	parser.add_option("-ct", "--content_type", "Content Type", "all")
	
	parser.parse(args)
	
	var content_type: String = parser.get_option("-ct")
	var source_reference_list: SourceReferenceList = SourceReferenceList.new()

	if content_type == "all":
		for source_reference in source_reference_list.get_all_sources():
			var output: String = FormatText.format_source_reference(source_reference)
			Command.print_to_console(output)
	if content_type == "bible":
		for source_reference in source_reference_list.get_biblical_sources():
			var output: String = FormatText.format_source_reference(source_reference)
			Command.print_to_console(output)
	if content_type == "extrabiblical":
		for source_reference in source_reference_list.get_extrabiblical_sources():
			var output: String = FormatText.format_source_reference(source_reference)
			Command.print_to_console(output)
