@tool
extends EditorPlugin

class_name CMDEditor

const INTERFACE = preload("res://addons/cmd/interface/cmd_interface.tscn")

static var db:SQLite = SQLite.new()
var cmd_dock: VBoxContainer


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	var data_manager = DataManager.new()
	data_manager.create_initial_directories()
	CMDEditor.db.path = data_manager.get_scrollmapper_db_dir().path_join("database.sqlite")
	CMDEditor.db.open_db()
	
	cmd_dock = VBoxContainer.new()
	cmd_dock.name = "CMD"

	var label = Label.new()
	label.text = "Scrollmapper Command Line Interface"
	cmd_dock.add_child(label)

	var interface = INTERFACE.instantiate()
	interface.custom_minimum_size = Vector2(800, 200)
	interface.name = "CMD TextEdit"

	cmd_dock.add_child(interface)

	add_control_to_bottom_panel(cmd_dock, "CMD")
	
	var commands = Command.new()
	commands.initiate()
	commands.load_commands()

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_control_from_bottom_panel(cmd_dock)
	CMDEditor.db.close_db()
	
static func get_db():
	return CMDEditor.db
