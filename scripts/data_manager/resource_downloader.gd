@icon("res://images/icons/editor/ArrowDown.svg")
extends Node
class_name ResourceDownloader

signal download_complete(file_location:String)
signal download_failed()

@export var data_manager:DataManager

static var instance:ResourceDownloader = null
var http_request:HTTPRequest = null
var file_path:Types.DataDir = Types.DataDir.DATA
var file_name:String = "null"
var is_processing_request:bool = false

signal download_process_started
signal download_process_complete

func _ready() -> void:
	if instance == null:
		instance = self		
	http_request = HTTPRequest.new()
	add_child(http_request)	
	http_request.request_completed.connect(_http_request_completed)

func retrieve_source_list() -> void:
	file_name = "book_list.json"
	download_file(data_manager.source_list, Types.DataDir.SOURCES)
	Command.print_to_console("Retrieving book_list.json from %s"%data_manager.source_list)
	
func retrieve_book(book_name:String) -> void:
	var source_reference_list:SourceReferenceList = SourceReferenceList.new()
	file_name = book_name + ".json"
	var book_source:String = source_reference_list.get_book_source(book_name)
	if book_source.is_empty():
		Command.print_to_console("Book invalid. Run show_source_list in the Scrollmapper terminal to see which books are available.")
		return
	download_file(book_source, Types.DataDir.SOURCES)
	Command.print_to_console("Getting book '%s' from %s"%[book_name, book_source])
	
func download_file(file_url:String, file_path:Types.DataDir) -> void:
	is_processing_request = true
	download_process_started.emit()
	self.file_path = file_path
	var error = http_request.request(file_url)
	if error != OK:
		var error_message:String = "An error occurred in the HTTP request."
		Command.print_to_console(error_message)
		push_error(error_message)
		download_failed.emit()

func _http_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	var sources_file_path = data_manager.get_scrollmapper_sources_dir().path_join(file_name)
	var file = FileAccess.open(sources_file_path, FileAccess.WRITE)
	file.store_string(body.get_string_from_utf8())
	file.close()
	download_complete.emit(sources_file_path)
	Command.print_to_console("Download complete at %s"%sources_file_path)
	download_process_complete.emit()
	is_processing_request = false
