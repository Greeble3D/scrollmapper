extends Button

func _ready() -> void:
	pressed.connect(_on_exit_button_pressed)
	
func _on_exit_button_pressed() -> void:
	GameManager.load_level("HOME")
