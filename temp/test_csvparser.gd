extends Node2D

## This script is an example of how you can wrangle the CSV Parser.
## It's just a test of the parser, so it'll just print to the console and a label.
## It won't test the visual elements or anything.



func _ready() -> void:
	
	$BackButton.hide()
	
	## Example code to start Dialogue.
	var DialogueStarterInstance = DialogueStarter.new()
	var Dialogue_Path = $DialogueStarter.dialogue_csv
	await(DialogueStarterInstance.start_dialogue(Dialogue_Path)) # this is await because I wanted to hide the back button
		
	$BackButton.show()
	$BackButton.pressed.connect(_on_back_pressed)
	
	
func _on_back_pressed() -> void:
	##Example check for if dialogue is currently playing
	if (!Dialogue_Player.Dialogue_Playing):
		get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")
	
