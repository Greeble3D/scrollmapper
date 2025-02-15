extends CSVFormat

class_name CSVFormatScrollmapper

func _init(data: Array) -> void:
	super(data)
	
func get_csv() -> String:
	var csv_lines:PackedStringArray = []
	var headers = [
		"from_book",
		"from_chapter",
		"from_verse",
		"to_book",
		"to_chapter_start",
		"to_chapter_end",
		"to_verse_start",
		"to_verse_end",
		"votes",
		"user_added"
	]
	csv_lines.append(",".join(headers))

	for line in lines:
		csv_lines.append(line.get_csv_line_standard())
	return "\n".join(csv_lines)
