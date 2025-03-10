extends BaseModel

class_name BookModel

var id: int = 0
var book_hash: int = 0
var book_name: String = ""
var translation: String = ""
var translation_id: int = 0

func _init(_translation: String):
	super._init()
	self.translation = _translation.to_lower()
	create_table()

func get_create_table_query() -> String:
	return """
	CREATE TABLE IF NOT EXISTS %s_books (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		book_hash INTEGER UNIQUE,
		book_name TEXT UNIQUE,
		translation_id INTEGER,
		FOREIGN KEY(translation_id) REFERENCES translations(id)
	);
	""" % translation

func save():
	# Check if the book name already exists
	var query = "SELECT id FROM %s_books WHERE book_name = ?;" % translation
	var save_result = get_results(query, [book_name])

	if save_result.size() > 0:
		# If the book already exists, set the id and avoid insertion
		id = save_result[0]["id"]
		print("Book already exists with ID: %d" % id)
	else:
		update_translation_id()
		# Insert the new book
		book_hash = get_book_hash()
		var insert_query = "INSERT INTO %s_books (book_name, translation_id, book_hash) VALUES (?, ?, ?);" % translation
		execute_query(insert_query, [book_name, translation_id, book_hash])
		
		# Retrieve the last inserted ID
		var last_id_result = get_results("SELECT last_insert_rowid() as id;")
		if last_id_result.size() > 0:
			id = last_id_result[0]["id"]

func update_translation_id():
	if translation_id == 0:
		var translation_model = BibleTranslationModel.new()
		var translation_data = translation_model.get_translation(translation)
		if translation_data.size() > 0:
			translation_id = translation_data["id"]
		else:
			print("Translation not found for abbreviation: %s" % translation)

func get_all_books():
	var query = "SELECT * FROM %s_books;" % translation
	return get_results(query)

# New method to get a book by name
func get_book_by_name(_book_name: String):
	var query = "SELECT * FROM %s_books WHERE book_name = ?;" % translation
	var book_result = get_results(query, [_book_name])
	
	if book_result.size() > 0:
		id = book_result[0]["id"]
		book_name = book_result[0]["book_name"]
		translation_id = book_result[0]["translation_id"]
		translation = translation  # Assuming translation is already set

# New method to get a book by id
func get_book_by_id(_id: int):
	var query = "SELECT * FROM %s_books WHERE id = ?;" % translation
	var book_result = get_results(query, [_id])
	if book_result.size() > 0:
		id = book_result[0]["id"]
		book_name = book_result[0]["book_name"]
		translation_id = book_result[0]["translation_id"]
		translation = translation  # Assuming translation is already set

# New method to get the entire book
func get_entire_book(book_name: String) -> Array:
	var verse_model = VerseModel.new(translation)
	return verse_model.get_verses(book_name)

## Finds a book based on partial match and returns the first book found.
func find_book_by_name(_book_name: String):
	var query = "SELECT * FROM %s_books WHERE book_name LIKE ?;" % translation
	var partial_result = get_results(query, ["%s" % ("%"+_book_name+"%")])
	if partial_result.size() > 0:
		self.id = partial_result[0]["id"]
		self.book_name = partial_result[0]["book_name"]
		self.translation_id = partial_result[0]["translation_id"]
		self.translation = translation  # Assuming translation is already set

# New method to get a book by hash
func get_book_by_hash(_book_hash: int) -> Dictionary:
	var query = "SELECT * FROM %s_books WHERE book_hash = ?;" % translation
	var book_result = get_results(query, [_book_hash])
	if book_result.size() > 0:
		id = book_result[0]["id"]
		book_name = book_result[0]["book_name"]
		translation_id = book_result[0]["translation_id"]
		translation = translation  # Assuming translation is already set
		return book_result[0]
	return {}
func delete():
	if id != null:
		# Delete all verses connected with this book
		var verse_model = VerseModel.new(translation)
		verse_model.delete_by_book_id(id)
				
		# Delete the book
		var query = "DELETE FROM %s_books WHERE id = ?;" % translation
		execute_query(query, [id])
	else:
		print("Book ID is not set, cannot delete the book.")

func _str() -> String:
	return "BookModel(id=%d, book_name='%s', translation='%s', book_hash=%d)" % [id, book_name, translation, book_hash]

func print_str():
	print(_str())

func is_book_installed(_book_name: String) -> bool:
	var query = "SELECT id FROM %s_books WHERE book_name = ?;" % translation
	var result = get_results(query, [_book_name])
	return result.size() > 0

func get_book_hash() -> int:
	return ScriptureService.get_book_hash(book_name)
