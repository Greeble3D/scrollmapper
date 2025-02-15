extends Node

class_name CrossReferenceCSV

# Variables
var id: int
var from_book: String
var from_chapter: int
var from_verse: int
var to_book: String
var to_chapter_start: int
var to_chapter_end: int
var to_verse_start: int
var to_verse_end: int
var votes: int
var user_added: int

# Initialize the class with data from a dictionary
func _init(data: Dictionary) -> void:
	id = data.get("id", 0)
	from_book = data.get("from_book", "")
	from_chapter = data.get("from_chapter", 0)
	from_verse = data.get("from_verse", 0)
	to_book = data.get("to_book", "")
	to_chapter_start = data.get("to_chapter_start", 0)
	to_chapter_end = data.get("to_chapter_end", 0)
	to_verse_start = data.get("to_verse_start", 0)
	to_verse_end = data.get("to_verse_end", 0)
	votes = data.get("votes", 0)
	user_added = data.get("user_added", 0)

# Generate a CSV line from the data
func get_csv_line_standard(separator: String = ",") -> String:
	var csv_elements = [
		from_book,
		str(from_chapter),
		str(from_verse),
		to_book,
		str(to_chapter_start),
		str(to_chapter_end),
		str(to_verse_start),
		str(to_verse_end),
		str(votes),
		str(user_added)
	]
	return separator.join(csv_elements)
