extends BaseModel

class_name CrossReferenceModel

var id: int  # Added id variable
var from_book: String
var from_chapter: int
var from_verse: int
var to_book: String
var to_chapter: int
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
		to_chapter INTEGER,
		to_verse_start INTEGER,
		to_verse_end INTEGER,
		votes INTEGER
	);
	"""

func save():
	var query = "INSERT INTO cross_reference (from_book, from_chapter, from_verse, to_book, to_chapter, to_verse_start, to_verse_end, votes) VALUES (?, ?, ?, ?, ?, ?, ?, ?);"
	execute_query(query, [from_book, from_chapter, from_verse, to_book, to_chapter, to_verse_start, to_verse_end, votes])

func get_all_cross_references():
	var query = "SELECT * FROM cross_reference;"
	return get_results(query)

func get_cross_references_with_verses(book: String, chapter: int, verse: int) -> Array:
	var query = """
	SELECT 
		cr.from_book, cr.from_chapter, cr.from_verse, cr.to_book, cr.to_chapter, cr.to_verse_start, cr.to_verse_end, v.text
	FROM 
		cross_reference cr
	JOIN 
		%s_verses v ON cr.to_book = (SELECT name FROM %s_books WHERE id = v.book_id)
					AND cr.to_chapter = v.chapter
					AND v.verse BETWEEN cr.to_verse_start AND cr.to_verse_end
	WHERE 
		cr.from_book = ?
		AND cr.from_chapter = ?
		AND cr.from_verse = ?
	ORDER BY 
		cr.votes DESC;
	""" % [translation, translation]
	return get_results(query, [book, chapter, verse])



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
