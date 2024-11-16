extends BaseModel

class_name VerseModel

#region Main variables...
var id: int = 0
var book_id: int = 0
var chapter: int = 0
var verse: int = 0
var text: String =""
var translation: String = ""
#endregion


func _init(_translation: String):
	super._init()
	self.translation = _translation.to_lower()
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

func get_verse(book_id: int, chapter: int, verse: int) -> Dictionary:
	var query = "SELECT * FROM %s_verses WHERE book_id = ? AND chapter = ? AND verse = ?;" % translation
	var result = get_results(query, [book_id, chapter, verse])
	if result.size() > 0:
		self.id = result[0]["id"]
		self.book_id = result[0]["book_id"]
		self.chapter = result[0]["chapter"]
		self.verse = result[0]["verse"]
		self.text = result[0]["text"]
		return result[0]
	else:
		return {}


# New delete function
func delete():
	if id != null:
		var query = "DELETE FROM %s_verses WHERE id = ?;" % translation
		execute_query(query, [id])
	else:
		print("Verse ID is not set, cannot delete the verse.")

func format_verse(book:String, chapter:int, verse:int, verse_text:String)->String:
	var book_formatted:String = cmd_style.color_quaternary_text(book)
	book_formatted = cmd_style.bold_text(book_formatted)
	var chapter_formatted:String = cmd_style.color_tertiary_text(str(chapter))
	var verse_formatted:String = cmd_style.color_secondary_text(str(verse))
	var verse_text_formatted:String = cmd_style.color_main_text(verse_text)
	return "%s %s:%s - %s" % [book_formatted, chapter_formatted, verse_formatted, verse_text_formatted]
