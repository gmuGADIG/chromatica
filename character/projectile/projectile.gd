extends Area2D
class_name PlayerProjectile

@export var velocity : Vector2
@export var projectile_gravity : float = 0.0
@export var projectile_damage : int = 1


# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta
	velocity.y += gravity * delta
	
func _on_body_entered(area):
	if area is EnemyHitbox:
		area.hit(DamageInfo.new(projectile_damage, DamageInfo.AttackColor.RED))
	queue_free()
	
