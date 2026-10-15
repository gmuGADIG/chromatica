extends Area2D

@export var velocity : Vector2
@export var projectile_gravity : float = 0.0
@export var projectile_speed : float = 1500.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# placeholder
	position = Vector2(0, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += Vector2(projectile_speed, projectile_gravity)
	
func _on_body_entered(world):
	queue_free()
	
#put elsewhere:
#var projectileScene = preload("res://projectile.tscn")
#
#var instance = projectileScene.instantiate()
#add_child(instance)
