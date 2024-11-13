extends Node

class_name TextToVerses

# Signal emitted when verses are processed
signal verses_processed(verses)

var translation: String

# Function to set the translation
func set_translation(translation_name: String):
	translation = translation_name

func read_text_file(file_path: String) -> Array:
	var verses = []
	var current_book = ""
	var current_chapter = 0

	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		current_book = file.get_line().replace("#", "").strip_edges()  # Read the book name from the first line
		
		var full_text = file.get_as_text()  # Read the entire text file content
		var regex = RegEx.new()
		regex.compile(r"\*\*\[(\d+):(\d+)\]\*\*")

		var matches = regex.search_all(full_text)
		for i in range(matches.size()):
			var match = matches[i]
			var chapter = match.get_string(1).to_int()
			var verse = match.get_string(2).to_int()
			var start_pos = match.get_end(0)

			var end_pos = full_text.length()
			if i < matches.size() - 1:
				end_pos = matches[i + 1].get_start(0)
				
			var text = full_text.substr(start_pos, end_pos - start_pos).strip_edges()

			verses.append({"book": current_book, "chapter": chapter, "verse": verse, "text": text})
		
		file.close()

	emit_signal("verses_processed", verses)
	return verses

func save_verses_to_models(verses: Array):
	var book_name = verses[0]["book"]
	
	var book_model = BookModel.new(translation)
	book_model.book_name = book_name
	book_model.save()

	for verse in verses:
		var verse_model = VerseModel.new(translation)
		verse_model.book_id = book_model.id
		verse_model.chapter = verse["chapter"]
		verse_model.verse = verse["verse"]
		verse_model.text = verse["text"]
		verse_model.save()
		

func process_book(file_path: String):
	var verses = read_text_file(file_path)
	save_verses_to_models(verses)
