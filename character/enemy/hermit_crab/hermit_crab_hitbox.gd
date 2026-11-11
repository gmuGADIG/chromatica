extends EnemyHitbox
class_name HermitCrabHitbox

## While true, hits are ignored (no damage, no color change).
var invulnerable : bool = false


func hit(damage_info: DamageInfo) -> void:
	if invulnerable and not can_pierce_invulnerability(damage_info):
		return
	super(damage_info)


## Hook for the special attack type that works on a clammed crab.
## TODO: return true for explosions
func can_pierce_invulnerability(_damage_info: DamageInfo) -> bool:
	return false
