extends Control
class_name CutsceneSystem

##Array of custom type CutsceneFrame (Texture2D, Bool)
@export var cutscene_frames : Array[CutsceneFrame]
var CutsceneDisplay : TextureRect

func _ready() -> void:
	#Gets the CutsceneDisplay node, and connects the signal(s)
	CutsceneDisplay = get_node("CutsceneDisplay")
	Dialogue.curr_dialogue_line.connect(_on_dialogue_line_change)
	Dialogue.dialogue_finished.connect(_on_dialogue_finished)

##Function gets called when a line is changed, sets cutscene texture and dialogue state
func _on_dialogue_line_change(dialogue_line) -> void:
	
	#Assert if cutscene frame array too small for dialogue index
	#No offset because .size() returns starts from 1 and not 0??
	assert(!(dialogue_line > cutscene_frames.size()), "CUTSCENE ARRAY SIZE DOES NOT MATCH DIALOGUE LINE COUNT!!!!!!!!")
	
	# -1 because arrays start at 0 and csv starts at 1
	var CurrDialogueShow = cutscene_frames[dialogue_line - 1].Show_Dialogue
	var CurrTexture = cutscene_frames[dialogue_line - 1].Cutscene_Texture
	
	##IMPORTANT!!!! If Dialogue_Show is set to false, make sure that the string in the CSV is blank! (e.g: NULL,""
	if CurrDialogueShow == false:
		Dialogue.hide()
	else:
		Dialogue.show()
		
	#set texture
	CutsceneDisplay.set_texture(CurrTexture)

##Blanks out the texture once dialogue is finished
func _on_dialogue_finished() -> void:
	CutsceneDisplay.set_texture(null)
