extends BaseModel

class_name BookModel

var id: int = 0
var book_name: String = ""
var translation: String = ""

func _init(_translation: String):
	super._init()
	self.translation = _translation.to_lower()
	create_table()

func get_create_table_query() -> String:
	return "CREATE TABLE IF NOT EXISTS %s_books (id INTEGER PRIMARY KEY AUTOINCREMENT, book_name TEXT UNIQUE);" % translation

func save():
	# Check if the book name already exists
	var query = "SELECT id FROM %s_books WHERE book_name = ?;" % translation
	var save_result = get_results(query, [book_name])
	
	if save_result.size() > 0:
		# If the book already exists, set the id and avoid insertion
		id = save_result[0]["id"]
		print("Book already exists with ID: %d" % id)
	else:
		# Insert the new book
		var insert_query = "INSERT INTO %s_books (book_name) VALUES (?);" % translation
		execute_query(insert_query, [book_name])
		
		# Retrieve the last inserted ID
		var last_id_result = get_results("SELECT last_insert_rowid() as id;")
		if last_id_result.size() > 0:
			id = last_id_result[0]["id"]

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
		translation = translation  # Assuming translation is already set


## Finds a book based on partial match and returns the first book found.
func find_book_by_name(_book_name: String):
	var query = "SELECT * FROM %s_books WHERE book_name LIKE ?;" % translation
	var partial_result = get_results(query, ["%s" % ("%"+_book_name+"%")])
	if partial_result.size() > 0:
		id = partial_result[0]["id"]
		book_name = partial_result[0]["book_name"]
		translation = translation  # Assuming translation is already set


func delete():
	if id != null:
		var query = "DELETE FROM %s_books WHERE id = ?;" % translation
		execute_query(query, [id])
	else:
		print("Book ID is not set, cannot delete the book.")

func _str() -> String:
	return "BookModel(id=%d, book_name='%s', translation='%s')" % [id, book_name, translation]

func print_str():
	print(_str())
