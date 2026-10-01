extends Node

var Render_Text_Instantly
var Dialogue_Playing #this is to block movement actions.
signal Next_Dialogue

#always hide the scene on first load
func _ready() -> void:
	Dialogue_Player.hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		Render_Text_Instantly = true
		Next_Dialogue.emit()
		
func play_dialogue(dialogue_array) -> void:
	Render_Text_Instantly = false
	var Dialogue_Box = Dialogue_Player.get_child(0) #index is always 0 as its the first node in the Dialogue node
	var text_rate = 0.05 #in seconds
	
	Dialogue_Player.show()
	Dialogue_Playing = true
	
	##Loop over all dialogue lines in the array (I dont exactly know why minus 1 is required, but it is)
	for Dialogue_Line in dialogue_array.size() - 1:
		#Empties the text box, gets the current dialogue line in a string format, then splits
		#the current line into a character array
		Dialogue_Box.set_text("")
		var Dialogue_Text = dialogue_array[Dialogue_Line + 1].get_dialogue_text()
		var Dialogue_Char_Array = Dialogue_Text.split()
		
		##Loop over all characters in the dialog line
		for character in Dialogue_Char_Array.size():
			#If the user pressed space to render the current line, set the text box to the full line and exit the loop.
			if (Render_Text_Instantly):
				Dialogue_Box.set_text(Dialogue_Text)
				break
			#Otherwise, append the current character from the char array to the text box and wait for text_rate (in seconds)
			Dialogue_Box.text += Dialogue_Char_Array[character]
			await get_tree().create_timer(text_rate).timeout
		
		#Once a line has been completed, wait for the user to press space to go to the new line, and reset the render state.
		await Next_Dialogue
		Render_Text_Instantly = false
	
	Dialogue_Playing = false
	Dialogue_Player.hide()
		
