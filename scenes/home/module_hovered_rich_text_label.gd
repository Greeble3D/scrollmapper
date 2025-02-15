extends RichTextLabel
@export var home: Home 
@export var procedural_scroll_icon: TextureRect 

func _ready() -> void:
	home.launcher_focused.connect(_on_launcher_focused)
	procedural_scroll_icon.change_scroll_icon(text)

func _on_launcher_focused(name:String) -> void:
	if name == "":
		name = "Scrollmapper"
	text = name
	procedural_scroll_icon.change_scroll_icon(name)
