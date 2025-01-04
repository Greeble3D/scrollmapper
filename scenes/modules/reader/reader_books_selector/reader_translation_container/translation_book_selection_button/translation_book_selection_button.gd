extends Button

class_name TranslationBookSelectionButton

var translation:String = ""
var translation_abbrev:String = ""
var book:String = ""

func initiate(_translation:String, _translation_abbrev:String, _book:String) -> void:
	translation = _translation
	translation_abbrev = _translation_abbrev
	book = _book
	text = book
