extends Node
class_name DialogueStarter

@export_file_path("*.csv") var dialogue_csv: String

@onready var dialogue : Array[DialogueLine] = CSVParser.parse_dialogue(dialogue_csv)


##Takes in a path to a CSV and plays the dialogue inside of it. Returns true once dialogue is fully done, and false if it could not be played.
func start_dialogue() -> bool:
	return await(Dialogue_Player.play_dialogue(dialogue))
