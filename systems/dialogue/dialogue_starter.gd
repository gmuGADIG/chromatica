extends Node
class_name DialogueStarter

@export_file_path("*.csv") var dialogue_csv: String

##Takes in a path to a CSV and plays the dialogue inside of it. Returns true once dialogue is fully done, and false if it could not be played.
func start_dialogue(dialogue_csv_path) -> bool:
	if dialogue_csv_path != "":
		var dialogue := CSVParser.parse_dialogue(dialogue_csv_path)
		return await(Dialogue_Player.play_dialogue(dialogue))
	else:
		return false
