extends CanvasLayer

signal dialogue_finished

#dictionary
@export var npc_id_table : Dictionary[StringName,NPCData]
@export var dialogue_box : RichTextLabel
@export var character_portrait : TextureRect
@export var character_name_box : RichTextLabel

@export_group("Render Speeds")
@export var default_rate : float = 0.05 #in seconds
@export var exclamation_mark_rate : float = 0.5
@export var period_rate : float = 0.5
@export var comma_rate : float = 0.3
@export var question_mark_rate : float = 0.5
@export var fast_render_multiplier : float = 0.1

var active_dialogue : Array[DialogueLine] = []
var current_line : int = 0
var in_line : bool = false
var fast_render : bool = false


#always hide the scene on first load
func _ready() -> void:
	hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if not is_playing():
			return
		
		if in_line:
			fast_render = true
		elif current_line >= active_dialogue.size():
			active_dialogue = []
			hide()
			dialogue_finished.emit()
		else:
			_play_line()

func is_playing() -> bool:
	return not active_dialogue.is_empty()

##Plays the dialogue_array, type being [DialogueLine], outputeed from the parser.
func play(dialogue_array : Array[DialogueLine]) -> void:
	if is_playing():
		push_warning("Already in dialogue! Canceling old dialogue...")
	
	
	##Set initial parameters
	active_dialogue = dialogue_array
	current_line = 1
	fast_render = false
	show()
	_play_line()
	

func _play_line() -> void:
	in_line = true
	##Gets the current dialogue line in a string format, then splits the current line into a character array
	var line_text_raw : String = active_dialogue[current_line].get_dialogue_text()
	var character_id: String = active_dialogue[current_line].get_speaker_id()
	
	##render the dialogue sprite (200x200) & name
	##Checks to see if its not a NONE id and makes sure that the ID actually exists
	if character_id != "NONE" and npc_id_table.has(character_id):
		var this_npc_data : NPCData = npc_id_table[character_id]
		character_name_box.set_text(this_npc_data.name)
		character_portrait.set_texture(this_npc_data.portrait_sprite)
	else:
		character_name_box.set_text("")
		character_portrait.set_texture(null) #does this work? IDK! Yes it does!!
	
	##Make sure that the characters are not visible before loading the text
	dialogue_box.set_visible_characters(0)
	dialogue_box.set_text(line_text_raw)
	var line_text = dialogue_box.get_parsed_text()
	
	##Make a loop for the length of the chars in the current dialogue line plus one because offsets
	for i in range(1,line_text.length()+1):
		#print(i)
		##If the user pressed spaco render the current line, show all of the characters and exit the loop.
		#if (render_text_instantly):
			#dialogue_box.set_visible_characters(-1)
			#break
		#Otherwise, change the visible character count to the current character index wait for text_rate (in seconds)
		dialogue_box.set_visible_characters(i)
		var render_speed : float = _evaluate_render_speed(line_text[i-1])
		await get_tree().create_timer(render_speed).timeout
	
	current_line += 1
	#print(current_line)
	fast_render = false
	in_line = false
	##Finish Dialogue

func _evaluate_render_speed(char : String) -> float:
	if char.length() != 1:
		push_error("Incorrect number of characters")
	
	print(char)
	var rate : float = (
			period_rate if char == "."
			else comma_rate if char == ","
			else question_mark_rate if char == "?"
			else exclamation_mark_rate if char == "!"
			else default_rate
	)
	
	if fast_render:
		rate *= fast_render_multiplier
	return rate
