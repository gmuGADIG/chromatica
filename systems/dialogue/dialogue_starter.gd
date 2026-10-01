extends Node
class_name DialogueStarter

#func _ready() -> void:
#	print("asdf")
#	start_dialogue("res://system/dialogue/data/test_dialogue.csv")

static func start_dialogue(dialogue_path):
	print(dialogue_path)
	var dialogue := CSVParser.parse_dialogue(dialogue_path)
	Dialogue_Player.play_dialogue(dialogue)
	#print(dialogue[3].get_speaker_id())
	
