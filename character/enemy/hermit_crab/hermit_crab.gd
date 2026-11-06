extends GroundEnemy
class_name Hermit_Crab

@export var sprite: Sprite2D

func _ready() -> void:
	super()
	_update_player_ray()

func _think(delta: float) -> void:
	if can_see_player():
		set_target(get_player_center())
		move(delta)
	else:
		has_target = false
		patrol(delta)

func can_see_player() -> bool:
	if player_ray == null:
		return false
	return player_ray.get_collider() is Player
	
func attack() -> void:
	pass

func face(direction: int) -> void:
	super(direction)
	_update_player_ray()
	if sprite:
		sprite.flip_h = facing < 0

func _update_player_ray() -> void:
	if player_ray == null:
		return
	player_ray.target_position = Vector2(facing * sight_range, 0.0)
	
	player_ray.force_raycast_update()
