extends Area2D
class_name Cannonball
## Flies straight until it hits the player (damaging them) or the world.

@export var speed : float = 1400.0
@export var damage : int = 1
@export var attack_color : DamageInfo.AttackColor = DamageInfo.AttackColor.RED
## Seconds before it despawns on its own
@export var lifetime : float = 4.0

var _velocity : Vector2 = Vector2.ZERO
var _spent : bool = false


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	get_tree().create_timer(lifetime).timeout.connect(queue_free)


func launch(direction: Vector2) -> void:
	_velocity = direction.normalized() * speed
	rotation = direction.angle()


func _physics_process(delta: float) -> void:
	global_position += _velocity * delta


func _on_area_entered(area: Area2D) -> void:
	if _spent:
		return
	if EnemyHurtbox.try_damage_player(area, damage, attack_color):
		_spent = true
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	# The player is handled through their hitbox area, not their body.
	if _spent or body is Player:
		return
	_spent = true
	queue_free()
