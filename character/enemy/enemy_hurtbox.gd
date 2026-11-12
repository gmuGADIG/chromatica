extends Area2D
class_name EnemyHurtbox
## Damages the player while overlapping them. Re-hits every [member rehit_delay]
## seconds if the player stays inside.
## Place on collision layer 0; the mask must include the layer the PlayerHitbox is on.

@export var damage : int = 1
@export var attack_color : Paint.Hue = Paint.Hue.RED
## Seconds before this hurtbox can damage the player again
@export var rehit_delay : float = 1.0

signal hit_player

var _cooldown : float = 0.0
var knockback_force : float

func _ready() -> void:
	find_parent("")

func _physics_process(delta: float) -> void:
	_cooldown = maxf(_cooldown - delta, 0.0)
	if _cooldown > 0.0:
		return
	if monitoring:
		for area in get_overlapping_areas():
			if try_damage_player(area, damage, attack_color):
				_cooldown = rehit_delay
				hit_player.emit()
				return


## Stops this hurtbox from ever damaging the player again.
func disable() -> void:
	set_physics_process(false)
	set_deferred("monitoring", false)


## Damages the player if [param area] is the player's hitbox. Returns true if it was.
func try_damage_player(area: Area2D, amount: int, color: Paint.Hue) -> bool:
	# Areas on the same layer as the PlayerHitbox (other enemies' hitboxes, etc.)
	# also show up, so only accept ones that belong to the Player.
	if not (area is PlayerHitbox):
		return false
	
	var player_hitbox = area as PlayerHitbox

	var pos = self.position
	var dir_to_player_hitbox = pos.direction_to(player_hitbox.global_position)

	# Type safety
	var info := DamageInfo.new(amount, color, knockback_force, dir_to_player_hitbox)
	
	# More method call type safety
	player_hitbox.hit(info)
	return true
