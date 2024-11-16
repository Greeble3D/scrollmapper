extends Node

## Get a verse according to command: get_verse Genesis 1:1
func execute(command_string: String):
	var args:PackedStringArray = command_string.split(" ")
	var parser = ArgParser.new()
	
	parser.add_option("-t", "--translation", "Translation", "")
	parser.add_option("-b", "--book", "Book", "")
	parser.add_option("-c", "--chapter", "Chapter", "")
	parser.add_option("-v", "--verse", "Verse", "")
	parser.parse(args)

	var t:String = parser.get_option("-t")
	var b:String = parser.get_option("-b")
	var c:int = parser.get_option("-c").to_int()
	var v:int = parser.get_option("-v").to_int()
	var book:BookModel = BookModel.new(t)

	book.find_book_by_name(b)

	if book.id > 0:
		var verse:VerseModel = VerseModel.new(t)
		var verse_data:Dictionary = verse.get_verse(book.id, c, v)
		verse.id = verse_data["id"]
		verse.text = verse_data["text"]
		if verse.id > 0:
			print("%s %d:%d - %s" % [book.book_name, verse.chapter, verse.verse, verse.text])
			var formatted_verse = verse.format_verse(book.book_name, verse.chapter, verse.verse, verse.text)	
			print(formatted_verse)
			Command.print_to_console(formatted_verse)
		else:
			print("Verse not found.")
		
	else:
		print("Book not found.")
