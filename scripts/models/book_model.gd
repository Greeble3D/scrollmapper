extends BaseModel

class_name BookModel

var id: int
var book_name: String
var translation: String

func _init(translation: String):
	super._init()
	self.translation = translation.to_lower()
	create_table()

func get_create_table_query() -> String:
	return "CREATE TABLE IF NOT EXISTS %s_books (id INTEGER PRIMARY KEY AUTOINCREMENT, book_name TEXT UNIQUE);" % translation

func save():
	# Check if the book name already exists
	var query = "SELECT id FROM %s_books WHERE book_name = ?;" % translation
	var result = get_results(query, [book_name])
	
	if result.size() > 0:
		# If the book already exists, set the id and avoid insertion
		id = result[0]["id"]
		print("Book already exists with ID: %d" % id)
	else:
		# Insert the new book
		var insert_query = "INSERT INTO %s_books (book_name) VALUES (?);" % translation
		execute_query(insert_query, [book_name])
		
		# Retrieve the last inserted ID
		result = get_results("SELECT last_insert_rowid() as id;")
		if result.size() > 0:
			id = result[0]["id"]

func get_all_books():
	var query = "SELECT * FROM %s_books;" % translation
	return get_results(query)
