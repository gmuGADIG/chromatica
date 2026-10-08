extends CharacterBody2D
class_name Player

enum State{
	NONE,
	BRUSH_SWING,
	UPPERCUT,
	DASH_SLASH}

var state : State = State.NONE
