extends EditorExportPlugin

## When exporting the app, this plugin will create and copy features
## into the destination export folder. This was first created because 
## a default sqlite database is needed on install, so we copy it from
## the sources folder to the export folder.
class_name ExportManager

var install_sources_folder:String = "res://sources/"
var export_folder:String = ""

func _get_name() -> String:
	return "ExportManager"

func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) -> void:
	export_folder = get_directory_of_file(path)
	var error = DirAccess.make_dir_recursive_absolute(export_folder+"sources/")
	
	# Copy default database...
	copy(install_sources_folder+"database.sqlite", export_folder+"sources/database.sqlite")
	
	# Copy README.md file...
	copy(install_sources_folder+"README.md", export_folder+"sources/README.md")

## Get the directory of target file.
func get_directory_of_file(export_path:String)->String:
	var split_export_path:Array = export_path.split("/")
	var file_name:String = split_export_path[-1]
	var destination_dir = export_path.replace(file_name, "")
	return destination_dir

	
## Copies a given file from the directories folders to the export directory. 
func copy(source_file: String, destination_file: String) -> void:
	var content = load_from_file(source_file)
	save_to_file(destination_file, content)

## Saves a given content to a file.
func save_to_file(destination_file:String, content):
	var file = FileAccess.open(destination_file, FileAccess.WRITE)
	file.store_buffer(content)

## Loads a file from the given source file.
func load_from_file(source_file:String):
	var file = FileAccess.open(source_file, FileAccess.READ)
	var content = file.get_buffer(file.get_length())
	return content
