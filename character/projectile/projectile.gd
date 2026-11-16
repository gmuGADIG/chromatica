extends Area2D
class_name PlayerProjectile

@export var velocity : Vector2
@export var projectile_gravity : float = 0.0
@export var projectile_damage : int = 1


# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity.y += projectile_gravity * delta
	position += velocity * delta
	
func _on_body_entered(body):
	if body is Player: return
	else:
		queue_free()

func _on_area_entered(area):
	if area is EnemyHitbox:
		area.hit(DamageInfo.new(projectile_damage, Paint.Hue.RED))
		queue_free()
	if area is ObjectHitbox:
		area.hit(DamageInfo.new(projectile_damage, Paint.Hue.RED))
		queue_free()
