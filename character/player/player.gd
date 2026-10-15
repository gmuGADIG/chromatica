extends CharacterBody2D
class_name Player

enum State{
	NONE,
	BRUSH_SWING,
	PARRY,
	UPPERCUT,
	DASH_SLASH,
}

var state : State = State.NONE

func _ready() -> void:
	add_to_group("player")
