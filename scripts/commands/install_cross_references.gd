extends Node

class_name InstallCrossReferencesCommand

func execute(command_string: String) -> void:
	var install_cross_references = InstallCrossReferences.new("scrollmapper")
	install_cross_references.install()
	Command.instance.print_to_console("Cross references installed for translation 'scrollmapper'.")
