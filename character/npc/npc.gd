@tool
extends Node2D
class_name NPC

@export var npc_data : NPCData
@export_file_path("*.csv") var dialogue_csv: String 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.texture = npc_data.world_sprite
	$InteractableRegion/DialogueStarter.dialogue_csv = dialogue_csv
	$InteractableRegion/DialogueStarter.dialogue = CSVParser.parse_dialogue(dialogue_csv)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
