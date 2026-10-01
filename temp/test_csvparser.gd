extends Node2D

## This script is an example of how you can wrangle the CSV Parser.
## It's just a test of the parser, so it'll just print to the console and a label.
## It won't test the visual elements or anything.

# The dialogue file to load. This'll get set in the editor, not in code.
@export_file_path("*.csv") var dialogue_path: String
# A label to show the text on just for funsies
@export var label: RichTextLabel

func _ready() -> void:
	#var lines := CSVParser.parse_dialogue(dialogue_path)
	#for l: DialogueLine in lines: 
	#	print(l)
		## NOTE that for use in a label, we use ._to_string!!! Errors otherwise.
		# Godot's builtin to_string() and the DialogueLine class's _to_string() both 
		# work, but the class's _to_string() is used here for potential future 
		# flexibility (however unlikely, since it's only good for debug).
		#label.append_text(l._to_string() + "\n")
	DialogueStarter.start_dialogue("res://systems/dialogue/data/test_dialogue.csv")
	
	#$BackButton.grab_focus()
	#$BackButton.pressed.connect(_on_back_pressed)
	# Reveal the text gradually on-screen over 4 seconds
	#get_tree().create_tween().tween_property(label, "visible_ratio", 1, 4.0)
	
#func _on_back_pressed() -> void:
#	get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")
	
