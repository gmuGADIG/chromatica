extends Node2D

## This script is an example of how you can wrangle the CSV Parser.
## It's just a test of the parser, so it'll just print to the console and a label.
## It won't test the visual elements or anything.



func _ready() -> void:
	## Example code to start Dialogue.
	# Get a reference to a Dialogue Starter node, which stores a reference to a CSV.
	var DialogueStarterInstance = $DialogueStarter
	# Tell it to start its dialogue. You can connect a signal to this function too!
	DialogueStarterInstance.start_dialogue()
