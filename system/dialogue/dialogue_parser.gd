extends Object
class_name CSVParser

"""
Takes in a path to a CSV file representing dialogue and parses it into an Array[DialogueLine].
"""
static func parse_dialogue(path: String) -> Array[DialogueLine]:
	# TODO: make better error handling on invalid CSV or dialogue format
	
	var file := FileAccess.open(path, FileAccess.READ)
	var csv := file.get_as_text()
	var parsed := parse_csv_internal(csv)
	
	var dialogue_array : Array[DialogueLine] = []
	var prev_id := "";
	
	for dialogue_line in parsed:
		var id   := dialogue_line[0]
		var text := dialogue_line[1]
		
		if id == "":
			id = prev_id
		else:
			prev_id = id
		
		var line := DialogueLine.new(id, text)
		dialogue_array.push_back(line)
		
	return dialogue_array
	
static func parse_csv_internal(csv: String) -> Array[PackedStringArray]:
	var i := 0
	var length := len(csv)
	
	var string_builder := ""
	var line_builder := PackedStringArray()
	var final_array : Array[PackedStringArray] = []
	
	var in_string_quotes := false
	
	while i <= length:
		var chr := csv[i] if i < length else "\n"
		i += 1
		
		if chr == ',' and not in_string_quotes:
			line_builder.push_back(string_builder)
			string_builder = ""
		elif chr == '"':
			if i < length and csv[i] == '"':
				string_builder += '"'
				i += 1
			else:
				in_string_quotes = not in_string_quotes
		elif chr == '\n' and not in_string_quotes and (string_builder != "" or i < length):
			line_builder.push_back(string_builder)
			final_array.push_back(line_builder)
			line_builder = PackedStringArray()
			string_builder = ""
		else:
			string_builder += chr
	return final_array
