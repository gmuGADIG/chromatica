class_name Bomb
extends CharacterBody2D
## Falls under gravity. Once it lands, a fuse starts; when it runs out the bomb
## explodes, enabling an EnemyHurtbox that damages the player if they're in range.

signal armed
signal exploded

enum State { FALLING, ARMED, EXPLODING }

@export_group("Fuse")
## Seconds between landing and exploding
@export var fuse_time : float = 5.0

@export_group("Physics")
@export var gravity : float = 2500.0
@export var max_falling_velocity : float = 2000.0
## Slows the horizontal slide after landing (px/sec^2)
@export var ground_friction : float = 3000.0

@export_group("Explosion")
## Blast radius (px)
@export var explosion_radius : float = 200.0
@export var explosion_damage : int = 2
## How long the blast stays active/visible before the bomb is removed (sec)
@export var explosion_duration : float = 0.3
## Child EnemyHurtbox that does the damage (disabled until the explosion)
@export var explosion_hurtbox : EnemyHurtbox

@export_group("Placeholder Visuals")
@export var bomb_radius : float = 20.0

var state : State = State.FALLING
var _time_left : float = 0.0
var _flash_phase : float = 0.0


func _ready() -> void:
	_time_left = fuse_time
	# Dormant until the explosion. (Area2D errors if you query overlaps with monitoring off,
	# so the hurtbox's physics process is turned off too.)
	explosion_hurtbox.monitoring = false
	explosion_hurtbox.set_physics_process(false)
	explosion_hurtbox.damage = explosion_damage
	explosion_hurtbox.rehit_delay = 999.0 # one hit per explosion

	# Each bomb gets its own shape so radius changes don't leak between instances
	var shape_node := explosion_hurtbox.get_node("CollisionShape2D") as CollisionShape2D
	var circle := (shape_node.shape as CircleShape2D).duplicate() as CircleShape2D
	circle.radius = explosion_radius
	shape_node.shape = circle


func _physics_process(delta: float) -> void:
	if state == State.EXPLODING:
		return

	if not is_on_floor():
		velocity.y = minf(velocity.y + gravity * delta, max_falling_velocity)
	else:
		velocity.x = move_toward(velocity.x, 0.0, ground_friction * delta)
	move_and_slide()

	match state:
		State.FALLING:
			if is_on_floor():
				_arm()
		State.ARMED:
			_time_left -= delta
			# Blinks faster as the fuse runs down
			var urgency := 1.0 - clampf(_time_left / fuse_time, 0.0, 1.0)
			_flash_phase += delta * lerpf(3.0, 20.0, urgency)
			queue_redraw()
			if _time_left <= 0.0:
				_explode()


func _arm() -> void:
	state = State.ARMED
	_time_left = fuse_time
	armed.emit()


func _explode() -> void:
	state = State.EXPLODING
	velocity = Vector2.ZERO
	explosion_hurtbox.monitoring = true
	explosion_hurtbox.set_physics_process(true)
	exploded.emit()
	queue_redraw()

	await get_tree().create_timer(explosion_duration).timeout
	queue_free()


## Visual Indicator
func _draw() -> void:
	if state == State.EXPLODING:
		draw_circle(Vector2.ZERO, explosion_radius, Color(1.0, 0.5, 0.1, 0.6))
		return
	var blink := state == State.ARMED and sin(_flash_phase) > 0.0
	draw_circle(Vector2.ZERO, bomb_radius, Color.RED if blink else Color(0.15, 0.15, 0.15))
