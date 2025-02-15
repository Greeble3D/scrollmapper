extends Node

class_name CSVFormat

var lines: Array[CrossReferenceCSV] = []

func _init(data: Array) -> void:
	for entry in data:
		var cross_reference = CrossReferenceCSV.new(entry)
		lines.append(cross_reference)
