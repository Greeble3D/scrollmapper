extends BaseModel

class_name CrossReferenceModel

var id: int  # Added id variable
var from_book: String
var from_chapter: int
var from_verse: int
var to_book: String
var to_chapter_start: int
var to_chapter_end: int
var to_verse_start: int
var to_verse_end: int
var votes: int
var translation: String

func _init(translation: String):
	super._init()
	self.translation = translation.to_lower()
	create_table()

func get_create_table_query() -> String:
	return """
	CREATE TABLE IF NOT EXISTS cross_reference (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		from_book TEXT,
		from_chapter INTEGER,
		from_verse INTEGER,
		to_book TEXT,
		to_chapter_start INTEGER,
		to_chapter_end INTEGER,
		to_verse_start INTEGER,
		to_verse_end INTEGER,
		votes INTEGER
	);
	"""

func save():
	var query = "INSERT INTO cross_reference (from_book, from_chapter, from_verse, to_book, to_chapter_start, to_chapter_end, to_verse_start, to_verse_end, votes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);"
	execute_query(query, [from_book, from_chapter, from_verse, to_book, to_chapter_start, to_chapter_end, to_verse_start, to_verse_end, votes])

func get_all_cross_references():
	var query = "SELECT * FROM cross_reference;"
	return get_results(query)

func get_cross_references_for_verse(from_book: String, from_chapter: int, from_verse: int) -> Array:
	var query = """
	SELECT 
		cr.id AS cross_reference_id, cr.from_book, cr.from_chapter, cr.from_verse, 
		cr.to_book, cr.to_chapter_start, cr.to_chapter_end, cr.to_verse_start, cr.to_verse_end, cr.votes,
		v.id AS verse_id, v.book_id, v.chapter, v.verse, v.text,
		b.id AS book_id, b.book_name, b.translation_id,
		t.translation_abbr, t.title, t.license
	FROM 
		cross_reference cr
	JOIN 
		%s_books b ON cr.to_book = b.book_name
	JOIN 
		%s_verses v ON b.id = v.book_id
					AND v.chapter BETWEEN cr.to_chapter_start AND cr.to_chapter_end
					AND v.verse BETWEEN cr.to_verse_start AND cr.to_verse_end
	JOIN 
		translations t ON b.translation_id = t.id
	WHERE 
		LOWER(cr.from_book) = LOWER(?)
		AND cr.from_chapter = ?
		AND cr.from_verse = ?
	ORDER BY 
		cr.votes DESC;
	""" % [translation, translation]
	return get_results(query, [from_book, from_chapter, from_verse])

# New method to get a specific cross-reference
func get_cross_reference(id: int) -> Dictionary:
	var query = "SELECT * FROM cross_reference WHERE id = ?;"
	var result = get_results(query, [id])
	if result.size() > 0:
		return result[0]
	return {}

func delete():
	if id != null:
		var query = "DELETE FROM cross_reference WHERE id = ?;"
		execute_query(query, [id])
	else:
		print("Cross-reference ID is not set, cannot delete the entry.")
