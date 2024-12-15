extends Node

## This is a service that provides access to the meta data.
## It can fetch and set arbitrary meta data stored in the database.
## Interacts with the MetaModel to get and set data in the database.


## Gets meta data for a given key.
func get_meta_data(meta_key: String) -> Dictionary:
	var meta_model: MetaModel = MetaModel.new()
	var meta_data: Dictionary = meta_model.get_meta_data(meta_key)
	if meta_data.size() > 0:
		var json = JSON.new()
		var error = json.parse(meta_data['meta_data'])
		if error == OK:
			return json.data
		else:
			print("JSON Parse Error: ", json.get_error_message(), " in ", meta_data['meta_data'], " at line ", json.get_error_line())
			return {}
	return {}

## Sets meta data for a given key.
func set_meta_data(meta_key: String, meta_data: Dictionary):
	var meta_model: MetaModel = MetaModel.new()
	meta_model.set_meta_data(meta_key, meta_data)

## Deletes meta data for a given key.
func delete_meta_data(meta_key: String):
	var meta_model: MetaModel = MetaModel.new()
	var meta_data: Dictionary = meta_model.get_meta_data(meta_key)
	if meta_data.size() > 0:
		meta_model.delete()