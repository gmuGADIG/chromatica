extends Node2D

## This script is an example of how you can wrangle the CSV Parser.
## It's just a test of the parser, so it'll just print to the console and a label.
## It won't test the visual elements or anything.



func _ready() -> void:
	$BackButton.pressed.connect(_on_back_pressed)
	$BackButton.hide()
	
	## Example code to start Dialogue.
	# Get a reference to a Dialogue Starter node, which stores a reference to a CSV.
	var DialogueStarterInstance = $DialogueStarter
	# Tell it to start its dialogue. You can connect a signal to this function too!
	DialogueStarterInstance.start_dialogue()
	# Wait for the dialogue demo to be done to let the player leave.
	await Dialogue.dialogue_finished
	$BackButton.show()

	
	
func _on_back_pressed() -> void:
	##Example check for if dialogue is currently playing
	if (!Dialogue.Dialogue_Playing):
		get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")
	
