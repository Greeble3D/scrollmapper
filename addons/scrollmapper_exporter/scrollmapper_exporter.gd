@tool
extends EditorPlugin


func _enter_tree() -> void:
	var export_manager: ExportManager = ExportManager.new()
	add_export_plugin(export_manager)


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
