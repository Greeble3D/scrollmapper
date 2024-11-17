extends Resource

class_name DataManager

# The source list is a JSON file that contains a list of books and their metadata.
@export var source_list: String = "https://raw.githubusercontent.com/scrollmapper/book_list/refs/heads/main/book_list.json"

# Main scrollmapper data directory
@export var scrollmapper_data_dir:String = "scrollmapper_data"

# Create initial directories
func create_initial_directories():
	var dir = DirAccess.open(OS.get_user_data_dir())
	dir.make_dir_recursive(get_scrollmapper_data_dir())
	dir.make_dir_recursive(get_scrollmapper_sources_dir())
	dir.make_dir_recursive(get_scrollmapper_user_dir())
	dir.make_dir_recursive(get_scrollmapper_db_dir())

# Main scrollmapper data directory
func get_scrollmapper_data_dir() -> String:
	var data_dir:String = OS.get_user_data_dir()
	data_dir = data_dir.path_join(scrollmapper_data_dir)
	return data_dir

# Sources directory, where the source list is stored books are downloaded 
func get_scrollmapper_sources_dir() -> String:
	var data_dir:String = get_scrollmapper_data_dir()
	data_dir = data_dir.path_join("sources")
	return data_dir

# User directory, where user data is stored
func get_scrollmapper_user_dir() -> String:
	var data_dir:String = get_scrollmapper_data_dir()
	data_dir = data_dir.path_join("user")
	return data_dir

# Database directory, where SQLite database is stored
func get_scrollmapper_db_dir() -> String:
	var data_dir:String = get_scrollmapper_data_dir()
	data_dir = data_dir.path_join("database")
	return data_dir
