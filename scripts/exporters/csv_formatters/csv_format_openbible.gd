extends CSVFormat

class_name CSVFormatOpenBible

func _init(data: Array) -> void:
    super(data)

func get_csv() -> String:
    var csv_lines:PackedStringArray = []
    var headers = [
        "From Verse",
        "To Verse",
        "Votes",
        "#www.openbible.info format - https://www.openbible.info/labs/cross-references/"
    ]
    csv_lines.append("\t".join(headers))

    for line in lines:
        var from_verse = "%s.%d.%d" % [line.from_book, line.from_chapter, line.from_verse]
        var to_verse = "%s.%d.%d" % [line.to_book, line.to_chapter_start, line.to_verse_start]
        if line.to_chapter_end != line.to_chapter_start or line.to_verse_end != line.to_verse_start:
            to_verse += "-%s.%d.%d" % [line.to_book, line.to_chapter_end, line.to_verse_end]
        var csv_line = [
            from_verse,
            to_verse,
            str(line.votes)
        ]
        csv_lines.append("\t".join(csv_line))
    return "\n".join(csv_lines)