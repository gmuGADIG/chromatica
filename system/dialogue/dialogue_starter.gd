extends Node
class_name DialogueStarter

@export_file_path("*.csv") var dialogue_path: String

func _ready() -> void:
	print("asdf")
	start_dialogue("res://system/dialogue/data/test_dialogue.csv")

static func start_dialogue(dialogue_path):
	var dialogue := CSVParser.parse_dialogue(dialogue_path)
	print(dialogue[3].get_speaker_id())
	
