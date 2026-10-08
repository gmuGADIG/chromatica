extends CharacterBody2D
class_name Player


enum State{
	NONE,
	BRUSH_SWING,
	DASH_SLASH}

var state : State = State.NONE
@export var player_hitbox : PlayerHitbox
@export var health_component : HealthComponent
