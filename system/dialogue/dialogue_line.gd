extends Resource
class_name DialogueLine

var speaker_id: String
var dialogue_text: String

func _init(_speaker_id: String, _dialogue_text: String) -> void:
	speaker_id = _speaker_id
	dialogue_text = _dialogue_text

func get_dialogue_text() -> String:
	return dialogue_text
	
func get_speaker_id() -> String:
	return speaker_id
	
func _to_string() -> String:
	return speaker_id + ": " + dialogue_text
