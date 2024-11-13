extends Node

## Processes a book at a given path.
func execute(command_string: String):
	var args:PackedStringArray = command_string.split(" ")
	var parser = ArgParser.new()
	
	parser.add_option("-p", "--path", "Output file", "")
	parser.add_option("-t", "--translation", "Translation Abbreviation", "Scrollmapper")
	parser.parse(args)
	
	var path:String = parser.get_option("-p")
	var translation:String = parser.get_option("-t")
	var text_to_verses:TextToVerses = TextToVerses.new()
	text_to_verses.set_translation(translation)
	text_to_verses.process_book(path)

	
