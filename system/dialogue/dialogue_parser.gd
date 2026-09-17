extends Object
class_name CSVParser

# returns an Array[DialogueLine]
static func parse_dialogue_test(thing: Translation) -> Array:
	var file := FileAccess.open("res://system/dialogue/data/test_dialogue.csv", FileAccess.READ);
	var csv := file.get_as_text()
	var parsed = parse_csv_internal(csv)
	print(parsed)
	
	return []
	
static func parse_csv_internal(csv: String) -> Array[PackedStringArray]:
	var i := 0
	var length := len(csv)
	
	var string_builder := ""
	var line_builder := PackedStringArray()
	var final_array : Array[PackedStringArray] = []
	
	var in_string_quotes := false
	
	while i <= length:
		var char := csv[i] if i < length else "\n"
		i += 1
		
		if char == ',' and not in_string_quotes:
			line_builder.push_back(string_builder)
			string_builder = ""
		elif char == '"':
			if i < length and csv[i] == '"':
				string_builder += '"'
				i += 1
			else:
				in_string_quotes = not in_string_quotes
		elif char == '\n' and not in_string_quotes:
			line_builder.push_back(string_builder)
			final_array.push_back(line_builder)
			line_builder = PackedStringArray()
			string_builder = ""
		else:
			string_builder += char
	return final_array
