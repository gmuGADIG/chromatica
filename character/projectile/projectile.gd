extends Area2D
class_name PlayerProjectile

@export var velocity : Vector2
@export var projectile_gravity : float = 0.0
@export var projectile_damage : int = 1

var color: Paint.Hue = Paint.Hue.RED

func change_color(new_color: Paint.Hue) -> void:
	match new_color:
		Paint.Hue.RED:
			color = Paint.Hue.RED
			modulate = Color(1.0, 0.0, 0.0, 1.0)
		Paint.Hue.YELLOW:
			color = Paint.Hue.YELLOW
			modulate = Color(1.0, 0.775, 0.1, 1.0)
		Paint.Hue.BLUE:
			color = Paint.Hue.BLUE
			modulate = Color(0.1, 0.745, 1.0, 1.0)

func _physics_process(delta: float) -> void:
	velocity.y += projectile_gravity * delta
	position += velocity * delta
	
func _on_body_entered(body):
	if body is Player: return
	else:
		queue_free()

func _on_area_entered(area):
	if area is EnemyHitbox:
		area.hit(DamageInfo.new(projectile_damage, color))
		queue_free()
	if area is ObjectHitbox:
		area.hit(DamageInfo.new(projectile_damage, Paint.Hue.RED))
		queue_free()
