@abstract
class_name EnemyBehavior
extends Node

@export var acceleration : float
@export var deceleration : float
@export var max_velocity : float
@export var dampening : float
@export var gravity : float

@abstract func can_see_player()
@abstract func set_target(pos)
@abstract func move()
@abstract func attack()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
