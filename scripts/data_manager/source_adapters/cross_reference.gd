extends Node

class_name CrossReference

var from_book: String
var from_chapter: int
var from_verse: int
var to_book: String
var to_chapter: int
var to_verse_start: int
var to_verse_end: int
var votes: int

func _init(from_book: String, from_chapter: int, from_verse: int, to_book: String, to_chapter: int, to_verse_start: int, to_verse_end: int, votes: int):
	self.from_book = from_book
	self.from_chapter = from_chapter
	self.from_verse = from_verse
	self.to_book = to_book
	self.to_chapter = to_chapter
	self.to_verse_start = to_verse_start
	self.to_verse_end = to_verse_end
	self.votes = votes