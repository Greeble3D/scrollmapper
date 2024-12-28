extends GephiObject 

## A valid gephi connection object that can be used in a gephi network.

class_name GephiNode

var scripture_text: String = ""
var scripture_location: String = ""
var translation: String = ""
var book: String = ""
var chapter: int = 0
var verse: int = 0

func get_scripture_text() -> String:
    return scripture_text

func get_scripture_location() -> String:
    return scripture_location

func get_translation() -> String:
    return translation

func get_book() -> String:
    return book

func get_chapter() -> int:
    return chapter

func get_verse() -> int:
    return verse