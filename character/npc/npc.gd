@tool
extends Node2D
class_name NPC

@export var npc_data : NPCData:
	set(val):
		npc_data = val
		_on_npc_data_updated()
@export_file_path("*.csv") var dialogue_csv: String 

@onready var dialogue_starter : DialogueStarter = $InteractableRegion/DialogueStarter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_npc_data_updated()
	dialogue_starter.dialogue_csv = dialogue_csv
	dialogue_starter.dialogue = CSVParser.parse_dialogue(dialogue_csv)

func _on_npc_data_updated() -> void:
	$Sprite2D.texture = npc_data.world_sprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
