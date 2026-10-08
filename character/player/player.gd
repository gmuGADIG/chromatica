extends CharacterBody2D
class_name Player

enum State{
	NONE,
	BRUSH_SWING,
	DASH_SLASH,
	RANGED_ATTACK}

var state : State = State.NONE
