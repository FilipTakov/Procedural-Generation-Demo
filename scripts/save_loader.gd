class_name SaveLoader
extends Node

#Resources send their Dictionary form to convert to JSON
static func save_to_json(data : Dictionary) -> String:
	var json = JSON.new()
	var json_string = JSON.stringify(data, "\t")
	return json_string

#Consider Recursion to clean up sub-dictionaries for their Vector2i values. Like #If (current_data[key] = TYPE_DICTIONARY): current_data[key] = clean_json_for_dictionary()
#Problem 1: Array & Dictionary Mixed Recursion is a hell.
static func load_from_json(json_string : String) -> Dictionary:
	# Retrieve data
	var json = JSON.new()
	var error = json.parse(json_string)
	if error == OK:
		var data_received = json.data
		if typeof(data_received) == (TYPE_DICTIONARY):
			#Returns converted JSON to dictionary
			return SaveLoader.clean_json_for_dictionary_output(data_received)
		
		else:
			print("Unexpected data")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
	return {}


#Cleans entire dictionary Vec2I Strings
static func clean_json_for_dictionary_output(data : Dictionary) -> Dictionary:
	for key in data:
		var entry = data[key]
		
		# Vector String Cases
		if (typeof(entry) == TYPE_STRING):
			
			if (entry.begins_with("(") and entry.contains(",") and entry.ends_with(")")):
				data[key] = string_to_vector2i(data[key])
	return data

#Converts String form vector2is from a JSON output.
# String "(1,2)" -> VEC2I Vector2i(1,2)
static func string_to_vector2i(string := "") -> Vector2i:
	if string:
		var new_string: String = string
		new_string = new_string.erase(0, 1)
		new_string = new_string.erase(new_string.length() - 1, 1)
		var array: Array = new_string.split(", ")

		return Vector2i(int(array[0]), int(array[1]))
	return Vector2i.ZERO
