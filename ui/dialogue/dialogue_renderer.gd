extends CanvasLayer

signal next_dialogue


#dictionary
@export var npc_id_table : Dictionary[StringName,NPCData]
@export var dialogue_box : RichTextLabel
@export var character_portrait : TextureRect
@export var character_name_box : RichTextLabel
@export var text_rate = 0.05 #in seconds


var dialogue_playing : bool = false#this is to block movement actions.
var render_text_instantly : bool = false


#always hide the scene on first load
func _ready() -> void:
	hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		render_text_instantly = true
		next_dialogue.emit()

##Plays the dialogue_array, type being [DialogueLine], outputeed from the parser.
func play_dialogue(dialogue_array) -> bool:
	dialogue_playing = true
	render_text_instantly = false
	show()
	
	
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

			character_name_box.set_text(Dialogue_Chara_ID)
			character_portrait.set_texture(portrait_texture)
			
		else:
			character_name_box.set_text("")
			character_portrait.set_texture(null) #does this work? IDK!
		
		##Make sure that the characters are not visible before loading the text
		dialogue_box.set_visible_characters(0)
		dialogue_box.set_text(Dialogue_Text)
		
		##Make a loop for the length of the chars in the current dialogue line plus one because offsets
		for char_index in Dialogue_Char_Array.size() + 1:
			#If the user pressed space to render the current line, show all of the characters and exit the loop.
			if (render_text_instantly):
				dialogue_box.set_visible_characters(-1)
				break
			#Otherwise, change the visible character count to the current character index wait for text_rate (in seconds)
			dialogue_box.set_visible_characters(char_index)
			await get_tree().create_timer(text_rate).timeout
		
		#Once a line has been completed, wait for the user to press space to go to the new line, and reset the render state.
		await next_dialogue
		render_text_instantly = false
	
	dialogue_playing = false
	hide()
	print("END")
	return true	
