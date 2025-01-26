extends RichTextLabel
@export var home: Home 

func _ready() -> void:
	home.launcher_focused.connect(_on_launcher_focused)

func _on_launcher_focused(name:String) -> void:
	text = name
