extends Node

var Render_Text_Instantly
signal Next_Dialogue

func _ready() -> void:
	Dialogue_Player.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		Render_Text_Instantly = true
		Next_Dialogue.emit()
		
func play_dialogue(dialogue_array) -> void:
	Render_Text_Instantly = false
	var Dialogue_Box = Dialogue_Player.get_child(0)
	var curr_index = 1
	var dialogue_done = false
	var text_rate = 0.05

	
	
	Dialogue_Player.show()
	
	print(dialogue_array.size())
	for Dialogue_Line in dialogue_array.size():
		Dialogue_Box.set_text("")
		var Dialogue_Text = dialogue_array[Dialogue_Line + 1].get_dialogue_text()
		var Dialogue_Char_Array = Dialogue_Text.split()
		
		for char in Dialogue_Char_Array.size():
			print(dialogue_done)
			if (char == Dialogue_Char_Array.size() - 1):
				dialogue_done = true
			if (Render_Text_Instantly):
				dialogue_done = true
				break
				
			Dialogue_Box.append_text(Dialogue_Char_Array[char])
			await get_tree().create_timer(text_rate).timeout
			

		if (Render_Text_Instantly):
			Dialogue_Box.set_text(Dialogue_Text)
		
		if (dialogue_done):
			await Next_Dialogue
			Render_Text_Instantly = false
			print("awaited done")
