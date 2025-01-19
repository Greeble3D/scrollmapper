extends Node

## Slugify a string
func slugify(text: String) -> String:
	var slug = text.to_lower()
	slug = slug.replace(" ", "-")
	
	var regex = RegEx.new()
	regex.compile("[^a-z0-9-]")
	slug = regex.sub(slug, "-", true)
	
	return slug
