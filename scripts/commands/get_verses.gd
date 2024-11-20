extends Node

class_name  GetVerses

# Handles the execution of the get_book command.
func execute(command_string: String) -> void:

	var parser = ArgParser.new()
	parser.add_option("-t", "--translation", "Translation", "")
	parser.add_option("-b", "--book", "Book", "")
	parser.add_option("-c", "--chapter", "Chapter", "-1")
	parser.add_option("-v", "--verse", "Verse", "-1")
	parser.add_option("-eb", "--end_book", "End Book", "")
	parser.add_option("-ec", "--end_chapter", "End Chapter", "-1")
	parser.add_option("-ev", "--end_verse", "End Verse", "-1")
	parser.parse(command_string.split(" "))

	var t: String = parser.get_option("-t")
	var b: String = parser.get_option("-b")
	var c: int = parser.get_option("-c").to_int()
	var v: int = parser.get_option("-v").to_int()
	var eb: String = parser.get_option("-eb")
	var ec: int = parser.get_option("-ec").to_int()
	var ev: int = parser.get_option("-ev").to_int()
	var verse: VerseModel = VerseModel.new(t)

	var verses: Array = []
	if eb != "" and ec > 0 and ev > 0:		
		verses = verse.get_verses_by_range(b, c, v, eb, ec, ev)
	else:
		verses = verse.get_verses(b, c, v)

	if verses.size() > 0:
		for verse_data in verses:
			#print("%s %d:%d - %s" % [verse_data["book_name"], verse_data["chapter"], verse_data["verse"], verse_data["text"]])
			var formatted_verse = FormatText.format_verse(verse_data["book_name"], verse_data["chapter"], verse_data["verse"], verse_data["text"])
			Command.print_to_console(formatted_verse)
	else:
		print("Verses not found.")
