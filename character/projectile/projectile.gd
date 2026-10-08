extends Area2D

@export var velocity : Vector2
@export var projectile_gravity : float
@export var projectile_speed : float = 1500.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# placeholder
	velocity = Vector2(1, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
