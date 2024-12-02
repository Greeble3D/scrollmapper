extends MarginContainer

@export var explore: Explore 
@export var option_button_direction: OptionButton 
@export var button_add: Button 

## The number of verses selected
var verses_selected:int = 0
## The array of the selected verses
var selected_verses:Array[Verse] = []

signal search_results_received
## Option pressed triggers the close of the search results ui, nothing else.
signal option_pressed
signal add_verse(verse:Verse)

func _ready() -> void:
	explore.search_results_received.connect(emit_search_results_received)
	explore.option_pressed.connect(emit_option_pressed)
	explore.button_action_add_to_export_list_pressed.connect(modify_selected_verses)
	search_results_received.connect(reveal_search_results)
	option_pressed.connect(hide_search_results)
	button_add.pressed.connect(_on_button_add_pressed)
	hide()

func reveal_search_results() -> void:
	selected_verses = []
	verses_selected = 0
	button_add.text = get_add_button_text() 
	show()

func hide_search_results() -> void:
	selected_verses = []
	verses_selected = 0
	explore.clear_verses()
	hide()

## This specifically adds or removes verses from the selected_verses
## array. 
func modify_selected_verses(verse:Verse) -> void:
	if selected_verses.has(verse):
		selected_verses.erase(verse)
		verse.set_add_remove_verse_icon(true)
	else:
		selected_verses.append(verse)
		verse.set_add_remove_verse_icon(false)
	verses_selected = selected_verses.size()
	button_add.text = get_add_button_text()

func emit_search_results_received() -> void:
	search_results_received.emit()

func emit_option_pressed() -> void:
	option_pressed.emit()

func get_add_button_text() -> String:
	return "Add Verses (%s)" % str(verses_selected)

## Sends a request to ScriptureService to populate the vx_graph with the 
## new scripture nodes selected.
func request_verses_to_vx_graph():
	var relationship: String
	match option_button_direction.get_selected_id():
		0:
			relationship = "separate"
		1:
			relationship = "linear"
		2:
			relationship = "parallel"
		_:
			relationship = "separate"

	## The verses should be sorted before sending them to the vx_graph,
	## in case the user selected them in a random order. 
	var verses_sorted:Array[Verse] = get_selected_verses_sorted()

	## From this point the verses should be used in a special 
	## request to the vx_graph to populate the graph with the verses.
	## TO-DO 12/2/2024

func get_selected_verses_sorted() -> Array[Verse]:
	var verse_ids:Array[int] = []
	for verse:Verse in selected_verses:
		verse_ids.append(verse.verse_id)
	verse_ids.sort()
	var verses_sorted:Array[Verse] = []
	verses_sorted.resize(verse_ids.size())
	for verse:Verse in selected_verses:
		var idx:int = verse_ids.find(verse.verse_id)
		verses_sorted[idx] = verse
	return verses_sorted

func _on_button_add_pressed() -> void:
	request_verses_to_vx_graph()
	hide_search_results()
