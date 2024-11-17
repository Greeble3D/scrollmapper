extends Node

class_name InstallBook

var translation = ""
var source_reference:SourceReference = null
var book = ""
func _init(book:String) -> void:
	self.book = book.strip_edges()
	var source_reference_list:SourceReferenceList = SourceReferenceList.new()
	source_reference = source_reference_list.get_book(book)

	if source_reference.content_type == "extrabiblical":
		self.translation = "scrollmapper"
	else:
		self.translation = source_reference.book

func install():
	var data_manager:DataManager = DataManager.new()
	var book_path = data_manager.get_book_path(book)
	var book_file = FileAccess.open(book_path, FileAccess.READ)
	var book_text_file = book_file.get_as_text()
	var json = JSON.new()
	var error = json.parse(book_text_file)
	if error != OK:
		var error_message = "Error parsing book JSON."
		Command.print_to_console(error_message)
		push_error(error_message)
		return
	var data = json.data

	var translation_model = BibleTranslationModel.new()
	translation_model.translation_abbr = translation
	translation_model.title = translation.capitalize()
	translation_model.license = "Public Domain"
	translation_model.save()

	for book_data in data["books"]:
		var book_model = BookModel.new(translation)
		book_model.book_name = book_data["name"]
		book_model.save()

		for chapter_data in book_data["chapters"]:
			for verse_data in chapter_data["verses"]:
				var verse_model = VerseModel.new(translation)
				verse_model.book_id = book_model.id
				verse_model.chapter = verse_data["chapter"]
				verse_model.verse = verse_data["verse"]
				verse_model.text = verse_data["text"]
				verse_model.save()
