extends Node
class_name CrossReferenceList

var cross_references: Array[CrossReference] = []

var book_names = {
	"Gen": "Genesis", "Exod": "Exodus", "Lev": "Leviticus", "Num": "Numbers", "Deut": "Deuteronomy",
	"Josh": "Joshua", "Judg": "Judges", "Ruth": "Ruth", "1Sam": "1 Samuel", "2Sam": "2 Samuel",
	"1Kgs": "1 Kings", "2Kgs": "2 Kings", "1Chr": "1 Chronicles", "2Chr": "2 Chronicles", "Ezra": "Ezra",
	"Neh": "Nehemiah", "Esth": "Esther", "Job": "Job", "Ps": "Psalms", "Prov": "Proverbs",
	"Eccl": "Ecclesiastes", "Song": "Song of Solomon", "Isa": "Isaiah", "Jer": "Jeremiah", "Lam": "Lamentations",
	"Ezek": "Ezekiel", "Dan": "Daniel", "Hos": "Hosea", "Joel": "Joel", "Amos": "Amos",
	"Obad": "Obadiah", "Jonah": "Jonah", "Mic": "Micah", "Nah": "Nahum", "Hab": "Habakkuk",
	"Zeph": "Zephaniah", "Hag": "Haggai", "Zech": "Zechariah", "Mal": "Malachi", "Matt": "Matthew",
	"Mark": "Mark", "Luke": "Luke", "John": "John", "Acts": "Acts", "Rom": "Romans",
	"1Cor": "1 Corinthians", "2Cor": "2 Corinthians", "Gal": "Galatians", "Eph": "Ephesians", "Phil": "Philippians",
	"Col": "Colossians", "1Thess": "1 Thessalonians", "2Thess": "2 Thessalonians", "1Tim": "1 Timothy", "2Tim": "2 Timothy",
	"Titus": "Titus", "Phlm": "Philemon", "Heb": "Hebrews", "Jas": "James", "1Pet": "1 Peter",
	"2Pet": "2 Peter", "1John": "1 John", "2John": "2 John", "3John": "3 John", "Jude": "Jude", "Rev": "Revelation"
}

func _init():
	var file_path = "res://sources/cross_references/cross_references.txt"
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		print("Failed to open file: " + file_path)
		return
	
	while not file.eof_reached():
		var line = file.get_line()
		if line.is_empty():
			continue
		
		var cross_reference = from_line(line)
		if cross_reference:			
			cross_references.append(cross_reference)
	file.close()


func from_line(line: String) -> CrossReference:
	var parts:PackedStringArray = line.split("\t")
	if parts.size() != 3:
		return null

	var from_book:String = ""
	var from_chapter:int = -1
	var from_verse:int = -1
	var to_book:String = ""
	var to_chapter:int = -1
	var to_verse_start:int = -1
	var to_verse_end:int = -1
	var votes:int = -1

	# EXAMPLE: Gen.1.1	1John.1.1	43
	# EXAMPLE: Gen.1.1	John.1.1-John.1.3	304

	var start:String = parts[0]
	var end:String = parts[1]
	votes = parts[2].to_int()
	var start_parts:PackedStringArray = start.split(".")
	from_book = book_names[start_parts[0]]
	from_chapter = start_parts[1].to_int()
	from_verse = start_parts[2].to_int()

	var end_parts_start:PackedStringArray
	var end_parts_end:PackedStringArray

	if is_destination_verse_set(line):
		var end_parts:PackedStringArray = end.split("-")
		end_parts_start = end_parts[0].split(".")
		end_parts_end = end_parts[1].split(".")	
		to_book = book_names[end_parts_start[0]]
		to_chapter = end_parts_start[1].to_int()		
		to_verse_start = end_parts_start[2].to_int()		
		to_verse_end = end_parts_end[2].to_int()
	else:
		end_parts_start = end.split(".")
		to_book = book_names[end_parts_start[0]]
		to_chapter = end_parts_start[1].to_int()
		to_verse_start = end_parts_start[2].to_int()
	
	return CrossReference.new(from_book, from_chapter, from_verse, to_book, to_chapter, to_verse_start, to_verse_end, votes)

# Determins whether or not the destination cross reference is a set of verses.
# Example that would return false: "Gen.1.1	Jer.32.17	73"
# Example that would return true: "Gen.1.1	Ps.89.11-Ps.89.12	46"
func is_destination_verse_set(line) -> bool:
	if not line.contains("-"):
		return false	
	var parts:PackedStringArray = line.split("\t")
	if parts[1].contains("-"):
		return true
	return false

func get_all_cross_references() -> Array:
	return cross_references
