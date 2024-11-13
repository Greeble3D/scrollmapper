extends BaseModel

class_name VerseModel

var book_id: int
var chapter: int
var verse: int
var text: String
var translation: String

func _init(translation: String):
	super._init()
	self.translation = translation.to_lower()
	create_table()

func get_create_table_query() -> String:
	return """
	CREATE TABLE IF NOT EXISTS %s_verses (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		book_id INTEGER,
		chapter INTEGER,
		verse INTEGER,
		text TEXT,
		FOREIGN KEY(book_id) REFERENCES %s_books(id)
	);
	""" % [translation, translation]

func save():
	# Check if verse already exists
	var query = "SELECT id FROM %s_verses WHERE book_id = ? AND chapter = ? AND verse = ?;" % translation
	var result = get_results(query, [book_id, chapter, verse])
	
	if result.size() > 0:
		# Update existing verse
		var update_query = "UPDATE %s_verses SET text = ? WHERE book_id = ? AND chapter = ? AND verse = ?;" % translation
		execute_query(update_query, [text, book_id, chapter, verse])
	else:
		# Insert new verse
		var insert_query = "INSERT INTO %s_verses (book_id, chapter, verse, text) VALUES (?, ?, ?, ?);" % translation
		execute_query(insert_query, [book_id, chapter, verse, text])

func get_all_verses():
	var query = "SELECT * FROM %s_verses;" % translation
	return get_results(query)
