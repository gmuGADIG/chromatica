extends Resource
## A container for a line of dialogue in the game. Contains a speaker ID and text.
class_name DialogueLine 

## Speaker ID
var speaker_id: String

## Speaker Text
var dialogue_text: String

## Creates a new DialogueLine with a given speaker ID and text.
func _init(_speaker_id: String, _dialogue_text: String) -> void:
	speaker_id = _speaker_id
	dialogue_text = _dialogue_text

## Gets the text associated with this DialogueLine.
func get_dialogue_text() -> String:
	return dialogue_text
	
## Gets the speaker ID associated with this DialogueLine.
func get_speaker_id() -> String:
	return speaker_id
	
# for debugging purposes
func _to_string() -> String:
	return speaker_id + ": " + dialogue_text
