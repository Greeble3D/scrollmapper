extends MarginContainer

@export var explore: Explore 

signal search_results_received
signal option_pressed

func _ready() -> void:
	explore.search_results_received.connect(emit_search_results_received)
	explore.option_pressed.connect(emit_option_pressed)
	search_results_received.connect(reveal_search_results)
	option_pressed.connect(hide_search_results)
	hide()

func reveal_search_results() -> void:
	show()

func hide_search_results() -> void:
	explore.clear_verses()
	hide()

func emit_search_results_received() -> void:
	search_results_received.emit()

func emit_option_pressed() -> void:
	option_pressed.emit()
