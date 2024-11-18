extends Node

## Command to install a book using the InstallBook process.
func execute(command_string: String):
	var args:PackedStringArray = command_string.split(" ")
	var parser = ArgParser.new()
	
	parser.add_option("-b", "--book", "Book", "")
	parser.parse(args)

	var book_name:String = parser.get_option("-b")
	if book_name == "":
		Command.print_to_console("Book name not provided.")
		print("Book name not provided.")
		return

	var install_book = InstallBook.new(book_name)
	install_book.install()
