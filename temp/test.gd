extends Node2D
@export_file_path("*.csv") var dialogue_path: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var lines := CSVParser.parse_dialogue(dialogue_path) # Replace with function body.
	for l in lines: print(l)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
