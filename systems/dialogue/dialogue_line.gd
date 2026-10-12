extends Resource
## A container for a line of dialogue in the game. Contains a speaker ID and text.
class_name DialogueLine 

## Speaker ID
var _speaker_id: String

## Speaker Text
var _dialogue_text: String

## Creates a new DialogueLine with a given speaker ID and text.
func _init(speaker_id: String, dialogue_text: String) -> void:
	self._speaker_id = speaker_id
	self._dialogue_text = dialogue_text

## Gets the text associated with this DialogueLine.
func get_dialogue_text() -> String:
	return _dialogue_text
	
## Gets the speaker ID associated with this DialogueLine.
func get_speaker_id() -> String:
	return _speaker_id
	
# for debugging purposes
func _to_string() -> String:
	return _speaker_id + ": " + _dialogue_text
