extends Node




#dictionary
@export var npc_id_table : Dictionary[StringName,NPCData]

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

##Plays the dialogue_array, type being [DialogueLine], outputeed from the parser.
func play_dialogue(dialogue_array) -> bool:
	Render_Text_Instantly = false
	var Dialogue_Box = Dialogue_Player.get_child(0) #index is always 0 as its the first node in the Dialogue node
	var Dialogue_Portrait = Dialogue_Player.get_child(1) #index is always 1 as its the second node in the Dialogue node
	var Character_Name_Box = Dialogue_Player.get_child(2) #index is always 2 as its the second node in the Dialogue node
	var text_rate = 0.05 #in seconds
	
	Dialogue_Player.show()
	Dialogue_Playing = true
	
	##Loop over all dialogue lines in the array (I dont exactly know why minus 1 is required, but it is)
	for Dialogue_Line in dialogue_array.size() - 1:
		##Gets the current dialogue line in a string format, then splits the current line into a character array
		var Dialogue_Text = dialogue_array[Dialogue_Line + 1].get_dialogue_text()
		var Dialogue_Chara_ID: String = dialogue_array[Dialogue_Line + 1].get_speaker_id()
		var Dialogue_Char_Array = Dialogue_Text.split()
		

		
		##render the dialogue sprite (200x200)
		##Checks to see if its not a NONE id and makes sure that the ID actually exists
		if Dialogue_Chara_ID != "NONE" && npc_id_table.has(Dialogue_Chara_ID):
			var thisNPCData = npc_id_table[Dialogue_Chara_ID]
			var portrait_texture = thisNPCData["portrait_sprite"]

			Character_Name_Box.set_text(Dialogue_Chara_ID)
			Dialogue_Portrait.set_texture(portrait_texture)
			
		else:
			Character_Name_Box.set_text("")
			Dialogue_Portrait.set_texture(null) #does this work? IDK!
		
		##Make sure that the characters are not visible before loading the text
		Dialogue_Box.set_visible_characters(0)
		Dialogue_Box.set_text(Dialogue_Text)
		
		##Make a loop for the length of the chars in the current dialogue line plus one because offsets
		for char_index in Dialogue_Char_Array.size() + 1:
			#If the user pressed space to render the current line, show all of the characters and exit the loop.
			if (Render_Text_Instantly):
				Dialogue_Box.set_visible_characters(-1)
				break
			#Otherwise, change the visible character count to the current character index wait for text_rate (in seconds)
			Dialogue_Box.set_visible_characters(char_index)
			await get_tree().create_timer(text_rate).timeout
		
		#Once a line has been completed, wait for the user to press space to go to the new line, and reset the render state.
		await Next_Dialogue
		Render_Text_Instantly = false
	
	Dialogue_Playing = false
	Dialogue_Player.hide()
	return true	
