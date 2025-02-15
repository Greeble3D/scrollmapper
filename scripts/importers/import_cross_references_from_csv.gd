extends Node

class_name ImportCrossReferencesFromCsv

var csv_lines: Array[CrossReferenceCSV] = []

func _init(csv_path: String) -> void:
	var file = FileAccess.open(csv_path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		import_csv(content)
		file.close()

func import_csv(content: String) -> void:
	var lines = content.split("\n", true)
	for i in range(1, lines.size()):  # Skip the header
		var line = lines[i]
		var fields = line.split(",", false)
		if fields.size() == 10:
			var data = {
				"from_book": fields[0],
				"from_chapter": fields[1].to_int(),
				"from_verse": fields[2].to_int(),
				"to_book": fields[3],
				"to_chapter_start": fields[4].to_int(),
				"to_chapter_end": fields[5].to_int(),
				"to_verse_start": fields[6].to_int(),
				"to_verse_end": fields[7].to_int(),
				"votes": fields[8].to_int(),
				"user_added": fields[9].to_int()
			}
			var cross_reference = CrossReferenceCSV.new(data)
			csv_lines.append(cross_reference)

func save_csv_to_cross_reference_database():
	for csv_line in csv_lines:
		var cross_reference = CrossReferenceModel.new("Scrollmapper")
		cross_reference.from_book = csv_line.from_book
		cross_reference.from_chapter = csv_line.from_chapter
		cross_reference.from_verse = csv_line.from_verse
		cross_reference.to_book = csv_line.to_book
		cross_reference.to_chapter_start = csv_line.to_chapter_start
		cross_reference.to_chapter_end = csv_line.to_chapter_end
		cross_reference.to_verse_start = csv_line.to_verse_start
		cross_reference.to_verse_end = csv_line.to_verse_end
		cross_reference.votes = csv_line.votes
		cross_reference.user_added = csv_line.user_added
		cross_reference.save()
