@tool
extends Node

## Command to download a book using ResourceDownloader.
func execute(command_string: String):
	if Engine.is_editor_hint():
		Command.print_to_console("Command not available in editor.")
		return
	
	var args:PackedStringArray = command_string.split(" ")
	var parser = ArgParser.new()
	
	parser.add_option("-b", "--book", "Book", "")
	parser.parse(args)

	var book_name:String = parser.get_option("-b")
	if book_name == "":
		Command.print_to_console("Book name not provided.")
		print("Book name not provided.")
		return

	ResourceDownloader.instance.retrieve_book(book_name)
