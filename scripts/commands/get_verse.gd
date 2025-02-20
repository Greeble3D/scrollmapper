extends Node

class_name GetVerse

# Handles the execution of the get_verse command.
func execute(command_string: String) -> void:
	var parser = ArgParser.new()
	parser.add_option("-t", "--translation", "Translation", "")
	parser.add_option("-b", "--book", "Book", "")
	parser.add_option("-c", "--chapter", "Chapter", "")
	parser.add_option("-v", "--verse", "Verse", "")
	parser.parse(command_string.split(" "))

	var t: String = parser.get_option("-t")
	var b: String = parser.get_option("-b")
	var c: int = parser.get_option("-c").to_int()
	var v: int = parser.get_option("-v").to_int()
	var book: BookModel = BookModel.new(t)

	book.find_book_by_name(b)

	if book.id > 0:
		var verse: VerseModel = VerseModel.new(t)
		var verse_data: Dictionary = verse.get_verse(book.id, c, v)
		print(verse_data)
		if verse_data.size() > 0:
			verse.id = verse_data["verse_id"]
			verse.chapter = verse_data["chapter"]
			verse.verse = verse_data["verse"]
			verse.text = verse_data["text"]
			print("%s %d:%d - %s" % [book.book_name, verse.chapter, verse.verse, verse.text])
			var formatted_verse = FormatText.format_verse(book.book_name, verse.chapter, verse.verse, verse.text)
			Command.print_to_console(formatted_verse)
		else:
			print("Verse not found.")
	else:
		print("Book not found.")
