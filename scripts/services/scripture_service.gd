extends Node

## This is a service that provides access to the scripture data.
## It can fetch cross-references, verses, and books, as well as 
## other related info.
## Interacts with models to get data from the database and is 
## used by the controllers to provide data to the views.

signal verses_searched(verses:Dictionary)
signal verse_cross_references_searched(verses:Dictionary)
signal books_installed

var translations = {}
var books = {}

func _ready():
	reload_data()
	books_installed.connect(reload_data)

func reload_data():
	load_translations()
	load_books()
	print("Scripture service data reloaded.")

func load_translations():
	translations.clear()
	var translation_model = BibleTranslationModel.new()
	var all_translations = translation_model.get_all_translations()
	for t in all_translations:
		translations[t["id"]] = t

func load_books():
	books.clear()
	var translation_model = BibleTranslationModel.new()
	var all_translations = translation_model.get_all_translations()
	for t in all_translations:
		var book_model = BookModel.new(t["translation_abbr"])
		var all_books = book_model.get_all_books()
		for b in all_books:
			b["translation"] = t["translation_abbr"]
			if t["id"] not in books:
				books[t["id"]] = {}
			books[t["id"]][b["id"]] = b
			
## Gets a single verse, one entry in an array.
func get_verse(translation: String, book: String, chapter: int, verse: int, meta:Dictionary = {}) -> Array:
	book = amend_book_name(book, translation)

	var verse_model: VerseModel = VerseModel.new(translation)
	var book_model: BookModel = BookModel.new(translation)
	book_model.get_book_by_name(book)
	var book_id: int = book_model.id
	
	var verse_data: Dictionary = verse_model.get_verse(book_id, chapter, verse)
	var translation_data: Dictionary = get_translation(translation)
	if verse_data.is_empty():
		return []
	return [{
		"verse_id": verse_data["verse_id"],
		"book_id": verse_data["book_id"],
		"chapter": verse_data["chapter"],
		"verse": verse_data["verse"],
		"text": verse_data["text"],
		"book_name": book_model.book_name,
		"translation_id": verse_data["translation_id"],
		"translation_abbr": translation_data["translation_abbr"],
		"title": translation_data["title"],
		"license": translation_data["license"],
		"meta": meta,
	}]

## Amends the book number according to roman numeral convention or integer. 
## This is necessary because sometimes the book name is called from cross references
## which uses an integer system alone. 
## This is a temporary function which should be replaced with a better solution.
func amend_book_name(book_name: String, translation: String) -> String:
	
	if translation == "KJV" && book_name == "Revelation":
		return "Revelation of John"

	var book_model = BookModel.new(translation)
	var all_books = book_model.get_all_books()
	var book_names = []
	for b in all_books:
		book_names.append(b["book_name"])

	# Check if the book name is in the list of books for the translation
	if book_name in book_names:
		return book_name

	# Check if the book name is in roman numeral format
	var roman_to_int = {
		"I": 1, "II": 2, "III": 3, "IV": 4, "V": 5, "VI": 6, "VII": 7, "VIII": 8, "IX": 9, "X": 10
	}
	var int_to_roman = {}
	for key in roman_to_int.keys():
		int_to_roman[roman_to_int[key]] = key

	# Check if the book name starts with an integer or roman numeral
	var first_word = book_name.split(" ")[0]
	if first_word in roman_to_int:
		book_name = str(roman_to_int[first_word]) + book_name.substr(first_word.length())
	elif first_word.is_valid_int():
		var int_value = int(first_word)
		if int_value in int_to_roman:
			book_name = int_to_roman[int_value] + book_name.substr(first_word.length())

	# If no match found, return the original book name
	return book_name

## Get verses by book, chapter, or specific verse
func get_verses(translation: String, book: String, chapter: int = -1, verse: int = -1) -> Array:
	var verse_model: VerseModel = VerseModel.new(translation)
	var verses: Array = verse_model.get_verses(book, chapter, verse)
	var result: Array = []
	for v in verses:
		result.append({
			"id": v["id"],
			"book_id": v["book_id"],
			"chapter": v["chapter"],
			"verse": v["verse"],
			"text": v["text"],
			"translation": translation
		})
	return result

## Get verses by range
func get_verses_by_range(translation: String, start_book: String, start_chapter: int, start_verse: int, end_book: String, end_chapter: int, end_verse: int) -> Array:
	var verse_model = VerseModel.new(translation)
	var verses = verse_model.get_verses_by_range(start_book, start_chapter, start_verse, end_book, end_chapter, end_verse)
	var result = []
	for v in verses:
		result.append(v)
	return result

## Get cross references for a verse
func get_cross_references_for_verse(translation: String, book: String, chapter: int, verse: int) -> Array:
	var cross_reference_model = CrossReferenceModel.new(translation)
	var cross_references = cross_reference_model.get_cross_references_for_verse(book, chapter, verse)
	
	var result = []
	for cr in cross_references:
		result.append(cr)
	return result

## Get all cross references for all verses
func get_all_cross_references(translation: String) -> Array:
	var verse_model: VerseModel = VerseModel.new(translation)
	var all_verses: Array = verse_model.get_all_verses()
	var result: Array = []
	
	for verse in all_verses:
		var cross_references = get_cross_references_for_verse(
			translation, 
			verse["book_name"], 
			verse["chapter"], 
			verse["verse"]
		)
		for cr in cross_references:
			result.append(cr)
	
	return result

func get_all_cross_references_simple() -> Array:
	var cross_reference_model = CrossReferenceModel.new("scrollmapper")
	return cross_reference_model.get_all_cross_references()

## Saves a cross reference to database. 
func save_cross_reference(from_book: String, from_chapter: int, from_verse: int, to_book: String, to_chapter_start: int, to_chapter_end: int, to_verse_start: int, to_verse_end: int, votes: int, user_added: bool) -> void:
	var cross_reference_model = CrossReferenceModel.new("scrollmapper")
	if cross_reference_model.cross_reference_exists(from_book, from_chapter, from_verse, to_book, to_chapter_start, to_chapter_end, to_verse_start, to_verse_end, votes):
		return
	cross_reference_model.from_book = from_book
	cross_reference_model.from_chapter = from_chapter
	cross_reference_model.from_verse = from_verse
	cross_reference_model.to_book = to_book
	cross_reference_model.to_chapter_start = to_chapter_start
	cross_reference_model.to_chapter_end = to_chapter_end
	cross_reference_model.to_verse_start = to_verse_start
	cross_reference_model.to_verse_end = to_verse_end
	cross_reference_model.votes = votes
	cross_reference_model.user_added = user_added
	cross_reference_model.save()

## Requests a cross  list.
func request_cross_references(translation: String, book: String, chapter: int, verse: int) -> void:
	var cross_references = get_cross_references_for_verse(translation, book, chapter, verse)
	propagate_cross_reference_search(translation, cross_references)

## Get information about a book
func get_book(translation: String, book_name: String) -> Dictionary:
	var book_model = BookModel.new(translation)
	book_model.get_book_by_name(book_name)
	return {
		"id": book_model.id,
		"book_name": book_model.book_name,
		"translation": book_model.translation
	}

## Get all chapter numbers in a book
func get_all_chapter_numbers_in_book(translation: String, book_name: String) -> Dictionary:
	var verse_model = VerseModel.new(translation)
	var chapters = verse_model.get_all_chapter_numbers(book_name)
	
	var results:Dictionary = {
		"chapters": []
	}
	for c in chapters:
		results["chapters"].append(c["chapter"])
	return results	

## Get all verse numbers in a chapter
func get_all_verse_numbers_in_chapter(translation: String, book_name: String, chapter: int) -> Dictionary:
	var verse_model = VerseModel.new(translation)
	var verses = verse_model.get_all_verse_numbers(book_name, chapter)
	
	var results:Dictionary = {
		"verses": []
	}
	for v in verses:
		results["verses"].append(v["verse"])
	return results

## Get all books for a specific translation
func get_all_books(translation: String) -> Array:
	var book_model = BookModel.new(translation)
	var all_books = book_model.get_all_books()
	var result = []
	for b in all_books:
		result.append({
			"id": b["id"],
			"book_name": b["book_name"],
			"translation": translation
		})
	return result

## Get information about a book by its ID
func get_book_by_id(translation_id:int, book_id: int) -> Dictionary:
	if books.has(translation_id):
		if books[translation_id].has(book_id):
			return books[translation_id][book_id]
	return {}

## Get information about a translation
func get_translation(translation_abbr: String) -> Dictionary:
	var translation_model = BibleTranslationModel.new()
	var translation_data = translation_model.get_translation(translation_abbr)
	if translation_data.is_empty():
		return {}
	return {
		"id": translation_data["id"],
		"translation_abbr": translation_data["translation_abbr"],
		"title": translation_data["title"],
		"license": translation_data["license"]
	}

## Get all translations
func get_all_translations() -> Array:
	var translation_model = BibleTranslationModel.new()
	var all_translations = translation_model.get_all_translations()
	var result = []
	for t in all_translations:
		result.append({
			"id": t["id"],
			"translation_abbr": t["translation_abbr"],
			"title": t["title"],
			"license": t["license"]
		})
	return result

## Get information about a translation by its ID
func get_translation_by_id(translation_id: int) -> Dictionary:
	if translation_id in translations:
		return translations[translation_id]
	return {}

## Initiate a text search based on the provided criteria.
## This function searches for verses in the scripture based on the given parameters.
## It supports different search scopes and translations.
##
## @param scope: The scope of the search, which determines the range of scriptures to search within.
##               It can be one of the following:
##               - Types.SearchScope.ALL_SCRIPTURE: Search in all scriptures.
##               - Types.SearchScope.COMMON_CANNONICAL: Search in common canonical scriptures.
##               - Types.SearchScope.EXTRA_CANNONICAL: Search in extra canonical scriptures.
## @param translation: The translation of the scripture to search in.
## @param text: The text to search for within the scriptures.
## @param book: (Optional) The specific book to search within. Default is an empty string, which means all books.
## @param chapter: (Optional) The specific chapter to search within. Default is -1, which means all chapters.
## @param meta: (Optional) Additional metadata for the search. Default is an empty dictionary.
##
## @return: void
func initiate_text_search(scope: Types.SearchScope, translation: String = "", text: String = "", book: String = "", chapter: int = -1, meta: Dictionary = {}) -> void:
	var verse_model = VerseModel.new(translation)
	var verse_model_scrollmapper = VerseModel.new("scrollmapper")
	var verses = []
	match scope:
		Types.SearchScope.ALL_SCRIPTURE:
			var verse_set_1 = verse_model.search_text(text, book, chapter)
			for v in verse_set_1:
				verses.append(v)
			var verse_set_2 = verse_model_scrollmapper.search_text(text, book, chapter)
			for v in verse_set_2:
				verses.append(v)
		Types.SearchScope.COMMON_CANNONICAL:
			verses = verse_model.search_text(text, book, chapter)
		Types.SearchScope.EXTRA_CANNONICAL:
			verses = verse_model_scrollmapper.search_text(text, book, chapter)
		_:
			verses = verse_model.search_text(text, book, chapter)
	propogate_search(translation, verses, meta)

## Initiates a search for a single verse in a specified translation and propagates the search results.
func initiate_verse_search(translation: String = "", book: String = "", chapter: int = -1, verse: int = -1, meta:Dictionary = {}):
	var verses = get_verse(translation, book, chapter, verse)
	propogate_search(translation, verses, meta)

## Initiates a search for a list of verses in a specified translation and propagates the search results.
func initiate_id_search(translation:String, verse_ids:Array[int], meta={}):
	var verse_model:VerseModel = VerseModel.new(translation)
	var verses = verse_model.get_verses_by_ids(verse_ids)
	propogate_search(translation, verses, meta)


## Initiates a search for a range of verses in a specified translation and propagates the search results.
##
## @param translation: The translation of the Bible to search in.
## @param start_book: The name of the book where the search starts.
## @param start_chapter: The chapter number where the search starts.
## @param start_verse: The verse number where the search starts.
## @param end_book: The name of the book where the search ends.
## @param end_chapter: The chapter number where the search ends.
## @param end_verse: The verse number where the search ends.
## @param meta: Optional metadata dictionary to include with the search.
func initiate_range_search(translation: String = "", start_book: String = "", start_chapter: int = -1, start_verse: int = -1, end_book: String = "", end_chapter: int = -1, end_verse: int = -1, meta:Dictionary = {}):
	var verses = get_verses_by_range(translation, start_book, start_chapter, start_verse, end_book, end_chapter, end_verse)
	propogate_search(translation, verses, meta)

## This *important* function handles search propagation to subscribed objects. It converts the array of verse results 
## from the database into a JSON string formatted for the API. This JSON string is then emitted via a signal 
## to be received by the subscribed objects.
func propogate_search(translation_abbr:String, verse_results:Array, meta:Dictionary={}):
	if verse_results.is_empty():
		return
	var results:Array = []
	for verse_result in verse_results:
		verse_result["translation"] = get_translation_by_id(verse_result["translation_id"])
		if books.has(verse_result["translation_id"]):
			verse_result["book"] = get_book_by_id(verse_result["translation_id"], verse_result["book_id"])
		results.append(verse_result)
	verses_searched.emit(apply_meta(results, meta))

## Derived from propagate_search, this tailors verse output to cross-reference data.
func propagate_cross_reference_search(translation_abbr:String, verse_results:Array, meta:Dictionary={}):
	
	if verse_results.is_empty():
		return
	var results:Array = []
	for verse_result in verse_results:	
		verse_result["translation"] = get_translation_by_id(verse_result["translation_id"])
		if books.has(verse_result["translation_id"]):
			verse_result["book"] = get_book_by_id(verse_result["translation_id"], verse_result["book_id"])
		verse_result['meta'] = meta
		results.append(verse_result)
	verse_cross_references_searched.emit(apply_meta(results, meta))

func emit_books_installed():
	books_installed.emit()

#region helper functions
func apply_meta(search_results:Array, meta:Dictionary) -> Array:
	if meta.is_empty():
		return search_results
	var i:int = 0
	for verse in search_results:
		var verse_id:int = verse["verse_id"]
		if meta.has(verse_id):
			search_results[i]["meta"]= meta[verse_id]
		i += 1
	return search_results

## This function takes a verse and a meta dictionary and creates a key based on the verse id,
## then places the meta in that key.
##
## Meta will take on various forms depending on which workstation uses it.
##
## Example:
##
## { 1814: { "work_space": "vx" } }
##
## Parameters:
## - verse: The verse object containing the verse_id.
## - meta: The dictionary containing metadata to be applied to the verse.
static func apply_verse_meta(verse:Verse, meta:Dictionary) -> Dictionary:
	return {verse.verse_id: meta}

## Will merge verse meta. Used in other functions directly after apply_verse_meta.
##
## When a process is creating a collection of verses to push to a workstation, they may have special directives attached to them (in the meta). 
## As verses are looped through, the meta_dictionary must be updated. That is what this function is responsible for.
##
## Parameters:
## - meta: The main meta dictionary.
## - verse_meta: The verse being appended to the dictionary.
static func merge_verse_meta(meta:Dictionary = {}, verse_meta:Dictionary = {}) -> Dictionary:
	meta.merge(verse_meta)
	return meta

#endregion
