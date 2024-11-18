extends Node
class_name FormatText

static func format_source_reference(source_reference: SourceReference) -> String:
	var cmd_style: CmdStyle = CmdStyle.new()
	var book_formatted: String = cmd_style.color_quaternary_text(source_reference.book)
	book_formatted = cmd_style.bold_text(book_formatted)
	var title_formatted: String = cmd_style.color_tertiary_text(source_reference.title)
	var language_formatted: String = cmd_style.color_secondary_text(source_reference.language)
	var content_type_formatted: String = cmd_style.color_main_text(source_reference.content_type)
	var output: String = "%s - %s: %s (%s)" % [language_formatted, book_formatted, title_formatted, content_type_formatted]
	return output

static func format_verse(book:String, chapter:int, verse:int, verse_text:String)->String:
	var cmd_style: CmdStyle = CmdStyle.new()
	var book_formatted:String = cmd_style.color_quaternary_text(book)
	book_formatted = cmd_style.bold_text(book_formatted)
	var chapter_formatted:String = cmd_style.color_tertiary_text(str(chapter))
	var verse_formatted:String = cmd_style.color_secondary_text(str(verse))
	var verse_text_formatted:String = cmd_style.color_main_text(verse_text)
	return "%s %s:%s - %s" % [book_formatted, chapter_formatted, verse_formatted, verse_text_formatted]
