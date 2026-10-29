extends Node2D
class_name RangedAttack
@export var player : Player
@export var projectile_packed : PackedScene
@export var launch_speed : float = 100.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#buffer, implement later

	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ranged_attack"):
		print("projectile shot")
		var shot : bool = do_shoot()
		if not shot:
			pass
	
			
func do_shoot() -> bool:
	if not player.state == Player.State.NONE:
		return false
	print("projectile shot")
	var new_projectile : PlayerProjectile = projectile_packed.instantiate()
	player.add_sibling(new_projectile)
	new_projectile.global_position = global_position
	var direction : Vector2 = get_local_mouse_position().normalized()
	new_projectile.velocity = direction * launch_speed
	
	return true
