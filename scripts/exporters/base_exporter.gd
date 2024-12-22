extends Node

class_name BaseExporter

# Common properties for all exporters
var export_data: Dictionary = {}

## Method to set the data to be exported
func set_export_data(data: Dictionary):
	export_data = data

## Abstract method to export data
## This method should be overridden by subclasses
func export() -> void:
	## This is an abstract method and should be implemented by subclasses
	assert(false, "export() method not implemented")

## Method to validate the data before exporting
## This method can be overridden by subclasses if needed
func validate_data() -> bool:
	## Basic validation logic
	return export_data.size() > 0

## Method to log export status
func log_status(message: String):
	print(message)
