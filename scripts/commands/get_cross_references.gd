extends Node

class_name GetCrossReferences

# Handles the execution of the get_cross_references command.
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
	var cross_reference_model: CrossReferenceModel = CrossReferenceModel.new(t)

	var cross_references: Array = cross_reference_model.get_cross_references_for_verse(b, c, v)
	if cross_references.size() > 0:
		for verse in cross_references:
			var from_book: String = verse["book_name"]
			var from_chapter: int = verse["chapter"]
			var from_verse: int = verse["verse"]
			var text: String = verse["text"]
			var formatted_reference: String = FormatText.format_verse(
			from_book, from_chapter, from_verse, text
			)
			Command.print_to_console(formatted_reference)
	else:
		print("No cross references found.")
