extends Node2D
class_name PlayerBrush
@export var player : Player
@export var player_movement : PlayerMovement
@export var hurtbox: PlayerHurtbox
@export_group("Attack Properties")
@export var brush_damage : int
@export var brush_recovery : float = 0.2

func _ready() -> void:
	hurtbox.enemy_hit.connect(func(enemy: EnemyHitbox) -> void:
		enemy.hit(DamageInfo.new(brush_damage,DamageInfo.AttackColor.RED))
	)

func _input(event: InputEvent):
	if event.is_action_pressed("brush_swing"):
		try_swing()

func try_swing() -> void:
	if player.state != Player.State.NONE:
		return
	
	if player.is_on_floor() and Input.is_action_pressed("look_up"):
		swing_brush(Vector2.UP)
	elif not player.is_on_floor() and Input.is_action_pressed("look_down"):
		swing_brush(Vector2.DOWN)
	else:
		var dir : Vector2 = Vector2(player_movement.last_horizontal_direction,0).normalized()
		swing_brush(dir)

func swing_brush(dir : Vector2) -> void:
	player.state = Player.State.BRUSH_SWING
	hurtbox.start_attack(dir)
	await hurtbox.finished
	get_tree().create_timer(brush_recovery).timeout.connect(
		func() -> void:
			player.state = Player.State.NONE
	)
