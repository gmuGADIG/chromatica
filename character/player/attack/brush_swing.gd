extends Node2D
class_name PlayerBrush
@export var player : Player
@export var player_movement : PlayerMovement
@export_group("Dimensions")
@export var brush_width : float = 256
@export var brush_length : float = 256

@export_group("Properties")
@export var brush_damage : DamageInfo
@export var hurtbox: PlayerHurtbox

func _ready() -> void:
	hurtbox.enemy_hit.connect(func(enemy: EnemyHitbox) -> void:
		enemy.hit(brush_damage)
	)

func _input(event: InputEvent):
	if event.is_action_pressed("brush_swing"):
		try_swing()

func try_swing() -> void:
	if player.is_on_floor() and Input.is_action_pressed("look_up"):
		brush_vertical()
		swing_brush(180*Vector2.UP)
	elif not player.is_on_floor() and Input.is_action_pressed("look_down"):
		brush_vertical()
		swing_brush(180*Vector2.DOWN)
	else:
		brush_horizontal()
		var dir : Vector2 = Vector2(player_movement.last_horizontal_direction,0).normalized()
		swing_brush(100*dir)

func brush_horizontal() -> void:
	hurtbox.set_size(Vector2(brush_width, brush_length))

func brush_vertical() -> void:
	hurtbox.set_size(Vector2(brush_length, brush_width))

func swing_brush(dir : Vector2) -> void:
	player.state = Player.State.BRUSH_SWING
	hurtbox.start_attack(dir)
