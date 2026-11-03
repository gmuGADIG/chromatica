extends Node2D
class_name GlobProjectile
## Flies straight until it hits the player (damaging them) or the world.

@export var speed : float = 1400.0
@export var damage : int = 1
## Seconds before it despawns on its own
@export var lifetime : float = 4.0

var _velocity : Vector2 = Vector2.ZERO
var _spent : bool = false

@onready var hurtbox : EnemyHurtbox = $EnemyHurtbox
@onready var particles : CPUParticles2D = $CPUParticles2D
@onready var sprite : Sprite2D = $Sprite2D
func _ready() -> void:
	get_tree().create_timer(lifetime).timeout.connect(queue_free)


func launch(direction: Vector2) -> void:
	_velocity = direction.normalized() * speed
	rotation = direction.angle()


func _physics_process(delta: float) -> void:
	global_position += _velocity * delta

func _on_enemy_hurtbox_body_entered(_body: Node2D) -> void:
	_velocity = Vector2.ZERO
	#hurtbox.monitoring = false
	hurtbox.set_deferred("monitoring", false)
	sprite.hide()
	var player : Player = get_tree().get_first_node_in_group("player")
	var dir : Vector2 = player.global_position.direction_to(global_position)
	particles.direction = dir
	particles.emitting = true
	await particles.finished
	queue_free()
