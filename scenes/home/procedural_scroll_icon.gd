extends TextureRect

@export var scroll_icons:Array[Texture2D]


func change_scroll_icon(text:String) -> void:
	var rng = RandomNumberGenerator.new()
	rng.seed = hash(text)
	var idx:int = rng.randi_range(0, scroll_icons.size())
	texture = scroll_icons[idx]
