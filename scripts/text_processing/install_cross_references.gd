extends Node

class_name InstallCrossReferences

var translation = ""
var cross_reference_list: CrossReferenceList = null

func _init(translation: String) -> void:
	self.translation = translation.strip_edges()
	cross_reference_list = CrossReferenceList.new()

func check_and_delete_existing_cross_references():
	var cross_reference_model = CrossReferenceModel.new(translation)
	var cross_references = cross_reference_model.get_all_cross_references()
	for cross_reference in cross_references:
		cross_reference_model.id = cross_reference["id"]
		cross_reference_model.delete()

func install():
	check_and_delete_existing_cross_references()
	print("Installing cross references for translation %s." % translation)
	for cross_reference in cross_reference_list.get_all_cross_references():
		var cross_reference_model = CrossReferenceModel.new(translation)
		cross_reference_model.from_book = cross_reference.from_book
		cross_reference_model.from_chapter = cross_reference.from_chapter
		cross_reference_model.from_verse = cross_reference.from_verse
		cross_reference_model.to_book = cross_reference.to_book
		cross_reference_model.to_chapter = cross_reference.to_chapter
		cross_reference_model.to_verse_start = cross_reference.to_verse_start
		cross_reference_model.to_verse_end = cross_reference.to_verse_end
		cross_reference_model.votes = cross_reference.votes
		cross_reference_model.save()
	
		
	
	Command.instance.print_to_console("Cross references for translation %s installed." % translation)