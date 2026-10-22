@abstract
class_name EnemyBehavior
extends CharacterBody2D
## This is the "brains" of an enemy
## Adds a child of an Ememy; it drives the enemy's body

@export_group("Movement")

## Rate the enemy speeds up (px/sec^2)
@export var acceleration : float = 3000.0

## Rate the enemy slows down when it has no movement target (px/sec^2)
@export var deceleration : float = 4000.0

## Top running speed (px/sec)
@export var max_velocity : float = 300.0

## How fast the enemy sheds speed when going faster than max_velocity (e.g. after a leap)
@export var dampening : float = 6000.0

## Downward acceleration (px/sec^2)
@export var gravity : float = 4000.0

@export_group("Combat")

@export var is_friendly : bool

@export var health_component : HealthComponent

@export var hitbox : EnemyHitbox

@export var health_bar : ProgressBar

@export var colorable_component : Colorable

@export var sight_ray : RayCast2D

@export var platform_ray : RayCast2D

@abstract func can_see_player() -> bool
@abstract func set_target(pos: Vector2) -> void
@abstract func move(delta: float) -> void
@abstract func attack() -> void


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
##func _process(delta: float) -> void:
##	pass
