extends Area2D


@export var force: float

enum ColorStates {
	RED, 
	BLUE, 
	YELLOW
}

var current_state : ColorStates = ColorStates.RED

@export var cooldown: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
