extends Area2D
class_name EnemyHurtbox
## Damages the player while overlapping them. Re-hits every [member rehit_delay]
## seconds if the player stays inside.
## Place on collision layer 0; the mask must include the layer the PlayerHitbox is on.

@export var damage : int = 1
@export var attack_color : DamageInfo.AttackColor = DamageInfo.AttackColor.RED
## Seconds before this hurtbox can damage the player again
@export var rehit_delay : float = 1.0

signal hit_player

var _cooldown : float = 0.0


func _physics_process(delta: float) -> void:
	_cooldown = maxf(_cooldown - delta, 0.0)
	if _cooldown > 0.0:
		return
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
static func try_damage_player(area: Area2D, amount: int, color: DamageInfo.AttackColor) -> bool:
	# Areas on the same layer as the PlayerHitbox (other enemies' hitboxes, etc.)
	# also show up, so only accept ones that belong to the Player.
	if not (area.get_parent() is Player) or not area.has_method("hit"):
		return false
	var info := DamageInfo.new(amount, color)
	# Set explicitly as well: DamageInfo._init currently shadows its own fields
	# with local vars, so the constructor arguments never get stored.
	info.damage = amount
	info.attack_color = color
	area.call("hit", info)
	return true
