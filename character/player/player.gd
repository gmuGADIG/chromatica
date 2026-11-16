extends CharacterBody2D
class_name Player

enum State{
	NONE,
	BRUSH_SWING,
	RANGED_ATTACK,
	SLAM,
	PARRY,
	UPPERCUT,
	DASH_SLASH,
	HEALING
}	

var state : State = State.NONE

func in_state(states : Array[State]) -> bool:
	return states.has(state) 
